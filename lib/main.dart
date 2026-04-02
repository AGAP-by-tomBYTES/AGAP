//main.dart - entry point of the app

//dependencies
import 'package:flutter/material.dart';
import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/agap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
initializes supabase and runs the app
ProviderScope is used for Riverpod state management
*/

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();
  
  runApp(const ProviderScope(
    child: Agap()
    )
  );
}