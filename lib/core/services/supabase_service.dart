
//dependencies
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/*
initialize supabase
 */
class SupabaseService {

  static bool isInitialized = false;

  static Future<void> initialize() async {
    //load env vars from .env file
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint(' .env not found: $e');
      return;
    }

    //read supabase config from env vars
    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_ANON_KEY'];

    //debug log for verifying that env vars are loaded correctly
    debugPrint('SUPABASE_URL: $url');
    debugPrint('SUPABASE_ANON_KEY: ${key != null ? 'found' : 'missing'}');

    //validation: anon key and url are non-empty
    if (url == null || url.isEmpty || key == null || key.isEmpty) {

      debugPrint('Supabase env vars missing or empty, skipping init.');
      return;
    }

    //initialize supabase with config from .env
    await Supabase.initialize(url: url, anonKey: key,);

    //set flag to true. supabase is successfully initialized
    isInitialized = true;
    debugPrint('Supabase initialized successfully.');
  }

  static SupabaseClient get client {
    if (!isInitialized) {
      throw Exception('Supabase not initialized.');
    }
    return Supabase.instance.client;
  }

}

