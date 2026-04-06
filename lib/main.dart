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
import 'package:agap/agap.dart';

/*
initialize supabase, hive, and run the app
*/
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Flutter bindings initialized");

  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  await Hive.initFlutter();
  debugPrint("Hive initialized");

  await Hive.openBox("app_cache");
  debugPrint("Hive box 'app_cache' opened");

  await NearbyService.init();
  debugPrint("Nearby connections initialized");

  SosQueueService.startQueueProcessor();
  debugPrint("Nearby connections initialized");

  await SupabaseService.initialize();
  debugPrint("Supabase initialized");

  debugPrint("Launching Agap app");
  runApp(const Agap());
}