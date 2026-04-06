import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/database/sos_queue.dart';
import 'package:agap/features/services/nearby_service.dart';
import 'package:agap/features/services/internet_service.dart';
import 'package:agap/core/services/supabase_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // ---------------------------------------------------------------------------
  // Shared state — reset in tearDown
  // ---------------------------------------------------------------------------
  final List<Map<String, dynamic>> sentPayloads = [];
  final List<String> uploadedAlertIds = [];

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------
  Future<void> seedHop({
    required String alertId,
    required String fromDevice,
    required int ttl,
    required String type,
  }) async {
    await AlertDao.insertReceivedAlert(
      alertId: alertId,
      fromDevice: fromDevice,
      ttl: ttl,
      type: type,
    );
  }

  void setupMocks({required bool isOnline}) {
    // Mock internet check
    InternetService.override = () async => isOnline;

    // Mock Nearby send — record payloads instead of using Nearby plugin
    NearbyService.testSendOverride = (Map<String, dynamic> alert) async {
      sentPayloads.add({
        'alertId': alert['id'],
        'ttl': alert['ttl'],
        'senderId': alert['senderId'],
      });
      debugPrint(
        'Simulated send of ${alert['id']} '
        'with TTL ${alert['ttl']} '
        'from ${alert['senderId']}',
      );
    };

    // Mock Supabase upload — record alert IDs instead of hitting the network
    SupabaseService.uploadOverride = (alert) async {
      uploadedAlertIds.add(alert.id);
      debugPrint('Simulated Supabase upload of ${alert.id}');
    };
  }

  Future<void> resetAll() async {
    InternetService.override = null;
    NearbyService.testSendOverride = null;
    NearbyService.clearSentCache();
    SupabaseService.uploadOverride = null;
    sentPayloads.clear();
    uploadedAlertIds.clear();
    await AlertDao.clearAllAlerts();
  }

  // ---------------------------------------------------------------------------
  // OFFLINE scenario
  // ---------------------------------------------------------------------------
  group('Multihop SOS Queue — OFFLINE', () {
    const alertId = 'ALERT_OFFLINE_001';
    const alertType = 'DANGER';

    setUp(() async {
      await resetAll();
      NearbyService.setConnectedEndpoints(['DEVICE_1', 'DEVICE_2', 'DEVICE_3']);
      setupMocks(isOnline: false);
    });

    tearDown(resetAll);

    test('Alert propagates through 3 hops', () async {
      // HOP 1 — originates from DEVICE_A, TTL 3
      debugPrint('--- HOP 1 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_A', ttl: 3, type: alertType);
      await SosQueueService.processQueue();

      // HOP 2 — received by DEVICE_1, TTL 2
      debugPrint('--- HOP 2 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_1', ttl: 2, type: alertType);
      await SosQueueService.processQueue();

      // HOP 3 — received by DEVICE_2, TTL 1
      debugPrint('--- HOP 3 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_2', ttl: 1, type: alertType);
      await SosQueueService.processQueue();

      // ── All alerts marked as forwarded ──
      final remaining = await AlertDao.getUnforwardedReceivedAlerts();
      expect(remaining, isEmpty,
          reason: 'All received alerts should be marked forwarded');

      // ── Correct number of hops forwarded ──
      expect(sentPayloads.length, 3,
          reason: 'Should forward exactly once per hop');

      // ── Correct TTL decrement per hop ──
      expect(sentPayloads[0]['ttl'], 2,
          reason: 'HOP 1: TTL should decrement from 3 to 2');
      expect(sentPayloads[1]['ttl'], 1,
          reason: 'HOP 2: TTL should decrement from 2 to 1');
      expect(sentPayloads[2]['ttl'], 0,
          reason: 'HOP 3: TTL should decrement from 1 to 0');

      // ── Correct sender per hop ──
      expect(sentPayloads[0]['senderId'], 'DEVICE_A');
      expect(sentPayloads[1]['senderId'], 'DEVICE_1');
      expect(sentPayloads[2]['senderId'], 'DEVICE_2');

      // ── Supabase was NOT called when offline ──
      expect(uploadedAlertIds, isEmpty,
          reason: 'Supabase should not be called when offline');

      // ── No duplicate alerts in DB ──
      final allAlerts = await AlertDao.getAlerts();
      final ids = allAlerts.map((a) => a.id).toList();
      expect(ids.toSet().length, equals(ids.length),
          reason: 'No duplicate alerts should exist in DB');

      debugPrint('Offline multihop test passed.');
    });
  });

  // ---------------------------------------------------------------------------
  // ONLINE scenario
  // ---------------------------------------------------------------------------
  group('Multihop SOS Queue — ONLINE', () {
    const alertId = 'ALERT_ONLINE_001';
    const alertType = 'SAFE';

    setUp(() async {
      await resetAll();
      NearbyService.setConnectedEndpoints(['DEVICE_1', 'DEVICE_2', 'DEVICE_3']);
      setupMocks(isOnline: true);
    });

    tearDown(resetAll);

    test('Alert propagates through 3 hops and Supabase upload is attempted each hop', () async {
      // HOP 1 — originates from DEVICE_A, TTL 3
      debugPrint('--- HOP 1 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_A', ttl: 3, type: alertType);
      await SosQueueService.processQueue();

      // HOP 2 — received by DEVICE_1, TTL 2
      debugPrint('--- HOP 2 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_1', ttl: 2, type: alertType);
      await SosQueueService.processQueue();

      // HOP 3 — received by DEVICE_2, TTL 1
      debugPrint('--- HOP 3 ---');
      await seedHop(alertId: alertId, fromDevice: 'DEVICE_2', ttl: 1, type: alertType);
      await SosQueueService.processQueue();

      // ── All alerts marked as forwarded ──
      final remaining = await AlertDao.getUnforwardedReceivedAlerts();
      expect(remaining, isEmpty,
          reason: 'All received alerts should be marked forwarded');

      // ── Correct number of hops forwarded ──
      expect(sentPayloads.length, 3,
          reason: 'Should forward exactly once per hop');

      // ── Correct TTL decrement per hop ──
      expect(sentPayloads[0]['ttl'], 2,
          reason: 'HOP 1: TTL should decrement from 3 to 2');
      expect(sentPayloads[1]['ttl'], 1,
          reason: 'HOP 2: TTL should decrement from 2 to 1');
      expect(sentPayloads[2]['ttl'], 0,
          reason: 'HOP 3: TTL should decrement from 1 to 0');

      // ── Correct sender per hop ──
      expect(sentPayloads[0]['senderId'], 'DEVICE_A');
      expect(sentPayloads[1]['senderId'], 'DEVICE_1');
      expect(sentPayloads[2]['senderId'], 'DEVICE_2');

      // ── Supabase upload was attempted once per hop ──
      expect(uploadedAlertIds.length, 3,
          reason: 'Supabase upload should be attempted once per hop');
      expect(uploadedAlertIds, everyElement(equals(alertId)),
          reason: 'All uploads should be for the same alert ID');

      // ── Received alerts marked as uploaded in DB ──
      final pendingUploads = await AlertDao.getPendingReceivedUploads();
      expect(pendingUploads, isEmpty,
          reason: 'All received alerts should be marked as uploaded after successful upload');

      // ── No duplicate alerts in DB ──
      final allAlerts = await AlertDao.getAlerts();
      final ids = allAlerts.map((a) => a.id).toList();
      expect(ids.toSet().length, equals(ids.length),
          reason: 'No duplicate alerts should exist in DB');

      debugPrint('Online multihop test passed.');
    });
  });
}