import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:agap/features/services/device_id.dart';
import 'package:agap/features/services/supabase_service.dart';
import 'package:agap/features/services/internet_service.dart';

class NearbyService {
  static const Strategy strategy = Strategy.P2P_CLUSTER;
  static final Nearby _nearby = Nearby();

  // Store connected devices
  static final List<String> _connectedEndpoints = [];

  /// Initialize Nearby (advertise + discover)
  static Future<void> init() async {
    try {
      await _startAdvertising();
      await _startDiscovery();
    } catch (e) {
      debugPrint('Nearby init error: $e');
    }
  }

  /// Start advertising (let others find you)
  static Future<void> _startAdvertising() async {
    await _nearby.startAdvertising(
      "AGAP_DEVICE",
      strategy,
      onConnectionInitiated: (id, info) {
        _nearby.acceptConnection(
          id,
          onPayLoadRecieved: _onPayloadReceived,
        );
      },
      onConnectionResult: (id, status) {
        if (status == Status.CONNECTED) {
          _connectedEndpoints.add(id);
          debugPrint('Connected (advertiser): $id');
        }
      },
      onDisconnected: (id) {
        _connectedEndpoints.remove(id);
        debugPrint('Disconnected: $id');
      },
    );
  }

  /// Start discovering nearby devices
  static Future<void> _startDiscovery() async {
    await _nearby.startDiscovery(
      "AGAP_DEVICE",
      strategy,
      onEndpointFound: (id, name, serviceId) async {
        await _nearby.requestConnection(
          "AGAP_DEVICE",
          id,
          onConnectionInitiated: (id, info) {
            _nearby.acceptConnection(
              id,
              onPayLoadRecieved: _onPayloadReceived,
            );
          },
          onConnectionResult: (id, status) {
            if (status == Status.CONNECTED) {
              _connectedEndpoints.add(id);
              debugPrint('Connected (discovery): $id');
            }
          },
          onDisconnected: (id) {
            _connectedEndpoints.remove(id);
          },
        );
      },
      onEndpointLost: (id) {
        debugPrint('Lost endpoint: $id');
      },
    );
  }

  /// Handle received alerts
  static Future<void> _onPayloadReceived(String endpointId, Payload payload) async {
    try {
      final jsonString = utf8.decode(payload.bytes!);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final alert = Alert.fromJson(data);


    // ignore own alerts
    final deviceId = await DeviceIdService.getDeviceId();
    if (alert.senderId == deviceId) return;

    // check ttl
    if (alert.ttl <= 0) {
      debugPrint('Dropped alert ${alert.id} (TTL expired)');
      return;
    }

    // duplicate check
    if (await AlertDao.alertExists(alert.id)) {
      return;
    }

    // save alert
    await AlertDao.insertAlert(alert);

    // forward
    await AlertDao.insertReceivedAlert(
      alertId: alert.id,
      fromDevice: alert.senderId,
      ttl: alert.ttl,
      type: alert.type,
    );

    debugPrint('Received alert ${alert.id} with TTL ${alert.ttl}');

    if (alert.ttl > 0) {
      final updatedAlert = alert.copyWith(ttl: alert.ttl - 1);

      await sendToAll(updatedAlert.toJson());

      if (await hasInternet()) {
        await SupabaseService.uploadAlert(alert);
      } else {
        debugPrint('No internet, will retry later via queue.');
      }

      debugPrint(
        'Forwarded alert ${alert.id} with new TTL ${updatedAlert.ttl}',
      );
    }
    
  } catch (e) {
    debugPrint('Payload error: $e');
    return;
  }
  }

  static final Set<String> _alreadySent = {}; // track per session

  /// send alert to all connected devices
  static Future<void> sendToAll(Map<String, dynamic> alert) async {

    // for testing only (DELETE FOR ACTUAL VER, see line 154)
    if (testSendOverride != null) {
      await testSendOverride!(alert);
      return;
    }

    final String alertId = alert['id'];

    if (_alreadySent.contains(alertId)) {
      debugPrint('Alert $alertId already sent in this session, skipping.');
      return;
    }

    _alreadySent.add(alertId);

    final String jsonString = jsonEncode(alert);
    final bytes = utf8.encode(jsonString);

    for (String endpoint in _connectedEndpoints) {
      try {
        await _nearby.sendBytesPayload(endpoint, bytes);
      } catch (e) {
        debugPrint('Send failed to $endpoint: $e');
      }
    }
  }


  /* ======= FOR UNIT TEST ONLY ======= */
  static void clearSentCache() => _alreadySent.clear();

  static List<String> get connectedEndpoints => List.unmodifiable(_connectedEndpoints);
  static Future<void> Function(Map<String, dynamic>)? testSendOverride;


  static void setConnectedEndpoints(List<String> endpoints) {
    _connectedEndpoints
      ..clear()
      ..addAll(endpoints);
  }
  
}