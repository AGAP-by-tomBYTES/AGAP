import 'dart:async';
import 'alert_dao.dart';
import 'package:flutter/foundation.dart';

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
        debugPrint('Forwarding alert ${alert['alertId']} from ${alert['fromDevice']}');
        await AlertDao.markAsForwarded(alert['alertId']);
      } catch (e) {
        debugPrint('Failed to forward alert ${alert['alertId']}: $e');
      }
    }
  }
}