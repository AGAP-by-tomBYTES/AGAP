//main.dart - entry point of the app

//dependencies
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/agap.dart';

/*
initialize supabase, hive, and run the app
*/
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Flutter bindings initialized");

  await Hive.initFlutter();
  debugPrint("Hive initialized");

  await Hive.openBox("app_cache");
  debugPrint("Hive box 'app_cache' opened");

  await SupabaseService.initialize();
  debugPrint("Supabase initialized");

  debugPrint("Launching Agap app");
  runApp(const Agap());
}