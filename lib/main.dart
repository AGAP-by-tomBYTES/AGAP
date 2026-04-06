//main.dart - entry point of the app

//dependencies
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/services/nearby_service.dart';
import 'package:agap/features/services/database/sos_queue.dart';
import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/core/services/navigation_service.dart';
import 'package:agap/agap.dart';

/*
initialize supabase, hive, and run the app
*/
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Flutter bindings initialized");

  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      debugPrint("initializing sqflite FFI");
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  await Hive.initFlutter();
  debugPrint("Hive initialized");

  final box = await Hive.openBox("app_cache");
  debugPrint("Hive box 'app_cache' opened");

  debugPrint("main: dumping hive contents");

  for (var key in box.keys) {
    final value = box.get(key);

    debugPrint("hive key = $key");
    debugPrint("hive type = ${value.runtimeType}");
    debugPrint("hive value = $value");
  }

  await SupabaseService.initialize();
  debugPrint("Supabase initialized");

  final cachedSession = box.get("supabase_session");
  final cachedRole = box.get("user_role");

  if (cachedSession != null) {
    debugPrint("restoring cached session...");

    try {
      if (cachedSession is! String) {
        debugPrint("main: Invalid session format detected");
        box.delete("supabase_session");
        throw Exception("Session is not a String");
      }
      await SupabaseService.client.auth.recoverSession(cachedSession);
      debugPrint("session restored");

      if (cachedRole == "resident") {
        NavigationService.initialRoute = Routes.residentDashboard;
      } else if (cachedRole == "responder") {
        NavigationService.initialRoute = Routes.responderDashboard;
      }
    } catch (e) {
      debugPrint("Failed to restore session: $e");
    }
  } else {
    debugPrint("No cached session");
  }

  if (!kIsWeb) {
    await NearbyService.init();
    debugPrint("Nearby connections initialized");
  }

  // SosQueueService.startQueueProcessor();
  // debugPrint("Nearby connections initialized");


  debugPrint("Launching Agap app");
  runApp(const Agap());
}