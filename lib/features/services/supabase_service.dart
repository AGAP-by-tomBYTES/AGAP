import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:agap/config/app_config.dart';

class SupabaseService {
  static final SupabaseClient? _client =
      AppConfig.isSupabaseConfigured ? Supabase.instance.client : null;

  static Future<void> uploadAlert(Alert alert) async {
    if (_client == null) return;

    try {
      await _client!.from('alerts').insert({
        'id': alert.id,
        'type': alert.type,
        'timestamp': alert.timestamp,
        'sender_id': alert.senderId,
      });
      debugPrint('Uploaded alert ${alert.id} to Supabase');
    } catch (e) {
      debugPrint('Supabase upload failed: $e');
    }
  }
}