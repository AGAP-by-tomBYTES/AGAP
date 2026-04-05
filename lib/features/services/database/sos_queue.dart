import 'dart:async';
import 'alert_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:agap/features/services/nearby_service.dart';
import 'package:agap/features/services/internet_service.dart';
import 'package:agap/features/services/supabase_service.dart';

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

    // for local alerts that can be sent immediately
    final List<Map<String, dynamic>> pendingLocal = await AlertDao.getPendingLocalUploads();
    for (final alertMap in pendingLocal) {
        final alert = Alert.fromJson(alertMap);
        
        if (await hasInternet()) {
          try {
              await SupabaseService.uploadAlert(alert);
              await AlertDao.markLocalUploaded(alert.id);
              debugPrint('Uploaded local alert ${alert.id} to Supabase');
          } catch (e) {
              debugPrint('Failed to upload local alert ${alert.id}: $e');
          }
        } else {
            debugPrint('No internet for local alert ${alert.id}, retry later');
        }
    }
    

    // get all unforwarded received alerts from db
    final List<Map<String, dynamic>> unforwardedAlerts =
        await AlertDao.getUnforwardedReceivedAlerts();

    // loop through each alert explicitly typed
    for (final alert in unforwardedAlerts) {
      try {
        int ttl = alert['ttl'] ?? 0;
        final String alertId = alert['alertId'];

        if (ttl <= 0) {
          debugPrint('Skipping expired alert $alertId');
          continue;
        }

        final type = alert['type']?.toString() ?? '';
        if (type != 'SAFE' && type != 'DANGER') {
          debugPrint('Skipping unknown type alert $alertId');
          await AlertDao.markAsForwarded(alertId);
          continue;
        }

        final forwardPayload = {
          'id': alertId,
          'type': type,
          'timestamp': alert['timestamp'],
          'senderId': alert['fromDevice'],
          'ttl': ttl - 1,
        };

        // forward to nearby
        debugPrint('Forwarding alert $alertId from ${alert['fromDevice']}');
        await NearbyService.sendToAll(forwardPayload);

        // upload if net is available
        try {
          if (await hasInternet()) {
            final alertObj = Alert.fromJson(forwardPayload);
            await SupabaseService.uploadAlert(alertObj);
            await AlertDao.markReceivedUploaded(alertId);
            debugPrint('Uploaded alert $alertId to Supabase');
          } else {
            debugPrint('No internet for alert $alertId, will retry later');
          }
        } catch (e) {
          debugPrint('Supabase upload failed for alert $alertId: $e');
        }

        // --- 3️⃣ Mark as forwarded locally ---
        await AlertDao.markAsForwarded(alertId);

      } catch (e) {
        debugPrint('Failed to process alert ${alert['alertId']}: $e');
      }
    }
  }
}