import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/device_id.dart';
import 'package:agap/features/services/internet_service.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:agap/features/services/models/alert_type.dart';
import 'package:agap/features/services/nearby_service.dart';
import 'package:agap/features/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class SosAlertService {
  static const int _defaultTtl = 5;
  static const Uuid _uuid = Uuid();

  static Future<Alert> sendAlert(String type) async {
    final normalizedType = type.toUpperCase();
    if (!AlertTypes.isSupported(normalizedType)) {
      throw ArgumentError.value(type, 'type', 'Unsupported alert type');
    }

    String senderId;
    try {
      senderId = await DeviceIdService.getDeviceId();
    } catch (e) {
      debugPrint('Failed to get device ID, using fallback: $e');
      senderId = 'fallback-${_uuid.v4()}';
    }

    final alert = Alert(
      id: _uuid.v4(),
      type: normalizedType,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      senderId: senderId,
      ttl: _defaultTtl,
    );

    try {
      await AlertDao.insertAlert(alert);
    } catch (e) {
      debugPrint('Failed to save alert locally: $e');
    }

    try {
      await NearbyService.sendToAll(alert.toJson());
    } catch (e) {
      debugPrint('Failed to relay alert nearby: $e');
    }

    try {
      if (await hasInternet()) {
        await SupabaseService.uploadAlert(alert);
        await AlertDao.markLocalUploaded(alert.id);
      }
    } catch (e) {
      debugPrint('Failed to upload alert online: $e');
    }

    return alert;
  }
}
