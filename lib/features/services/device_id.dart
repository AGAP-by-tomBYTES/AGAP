import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _key = 'device_id';

  /// return unique, persistent device ID for this app on this device
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    // return cached ID if it exists
    String? id = prefs.getString(_key);
    if (id != null) return id;

    // generate a new unique ID if needed
    if (Platform.isAndroid || Platform.isIOS) {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? const Uuid().v4();
      } else {
        // for android use UUID instead
        id = const Uuid().v4();
      }
    } else {
      // fallback for other platforms
      id = const Uuid().v4();
    }

    // save ID for future use
    await prefs.setString(_key, id);
    return id;
  }
}