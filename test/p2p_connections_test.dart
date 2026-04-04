import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/database/sos_queue.dart';
import 'package:agap/features/services/nearby_service.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Multihop SOS Queue Test - Simulate distinct devices', () {
    setUp(() async {
      // Clear DB and NearbyService cache
      await AlertDao.clearAllAlerts();
      NearbyService.clearSentCache();
      NearbyService.setConnectedEndpoints(['DEVICE_1', 'DEVICE_2', 'DEVICE_3']);
    });

    test('Alert should propagate correctly through 3 hops', () async {
      // Override sendToAll to simulate sending
      NearbyService.testSendOverride = (Map<String, dynamic> alert) async {
        final ttl = alert['ttl'];
        final id = alert['id'];
        final from = alert['senderId'];
        print('Simulated send of $id with TTL $ttl from $from to all connected endpoints');
      };

      // Step 0: Insert alert into received queue at DEVICE_A
      final Map<String, dynamic> alert = {
        'id': 'ALERT_001',
        'type': 'SAFE',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'fromDevice': 'DEVICE_A',
        'ttl': 3,
      };

      await AlertDao.insertReceivedAlert(
        alertId: alert['id'],
        fromDevice: alert['fromDevice'],
        ttl: alert['ttl'],
        type: alert['type'],
      );

      // --- HOP 1 ---
      print('--- HOP 1 ---');
      await SosQueueService.processQueue();

      // Insert as if received by DEVICE_1 for next hop
      await AlertDao.insertReceivedAlert(
        alertId: alert['id'],
        fromDevice: 'DEVICE_1',
        ttl: 2,
        type: alert['type'],
      );

      // --- HOP 2 ---
      print('--- HOP 2 ---');
      await SosQueueService.processQueue();

      // Insert as if received by DEVICE_2 for final hop
      await AlertDao.insertReceivedAlert(
        alertId: alert['id'],
        fromDevice: 'DEVICE_2',
        ttl: 1,
        type: alert['type'],
      );

      // --- HOP 3 ---
      print('--- HOP 3 ---');
      await SosQueueService.processQueue();

      // Verify all alerts are marked forwarded
      final remaining = await AlertDao.getUnforwardedReceivedAlerts();
      expect(remaining.length, 0);

      print('✅ Multihop test with distinct devices completed successfully.');
    });
  });
}