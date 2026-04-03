//main.dart - entry point of the app

//dependencies
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/agap.dart';


/*
initialize supabase, hive, and run the app
ProviderScope is used for Riverpod state management
*/

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("app_cache");

  await SupabaseService.initialize();

  runApp(const ProviderScope(
    child: Agap()
    )
  );
}