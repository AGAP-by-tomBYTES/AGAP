import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/models/alert.dart';

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
    );

    debugPrint('Received alert ${alert.id} with TTL ${alert.ttl}');
  } catch (e) {
    debugPrint('Payload error: $e');
  }
  }

  /// send alert to all connected devices
  static Future<void> sendToAll(Map<String, dynamic> alert) async {
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
  
}