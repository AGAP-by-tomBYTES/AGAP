import 'dart:async';
import 'alert_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:agap/features/services/nearby_service.dart';

class SosQueueService {
  static Timer? _timer;

  /// start periodic queue processing
  static void startQueueProcessor({Duration interval = const Duration(seconds: 5)}) {
    _timer = Timer.periodic(interval, (_) => processQueue());
  }

  /// stop processing
  static void stopQueueProcessor() {
    _timer?.cancel();
  }

  /// process unforwarded alerts
  static Future<void> processQueue() async {
    // get all unforwarded received alerts from db
    final List<Map<String, dynamic>> unforwardedAlerts =
        await AlertDao.getUnforwardedReceivedAlerts();

    // loop through each alert explicitly typed
    for (Map<String, dynamic> alert in unforwardedAlerts) {
      try {
        int ttl = alert['ttl'] ?? 0;

        // checker if expired for each alert in queue
        if (ttl <= 0) {
          debugPrint('Skipping expired alert ${alert['alertId']}');
          continue;
        }

        // skip if not a SAFE/DANGER alert (CHANGE if needed)
        if (alert['type'] != 'SAFE' && alert['type'] != 'DANGER') {
          debugPrint('Skipping unknown type alert ${alert['alertId']}');
          await AlertDao.markAsForwarded(alert['alertId']); // mark to avoid looping
          continue;
        }

        // decrease ttl
        final Map<String, dynamic> forwardPayload = {
        'id': alert['alertId'],
        'type': alert['type'],            // SAFE / DANGER
        'timestamp': alert['timestamp'],
        'senderId': alert['fromDevice'],  // original sender
        'ttl': ttl - 1,                      // decrement TTL for next hop
      };

        debugPrint('Forwarding alert ${alert['alertId']} from ${alert['fromDevice']}');
        await NearbyService.sendToAll(forwardPayload);
        await AlertDao.markAsForwarded(alert['alertId']);
      } catch (e) {
        debugPrint('Failed to forward alert ${alert['alertId']}: $e');
      }
    }
  }
}