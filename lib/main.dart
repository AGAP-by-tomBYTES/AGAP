//main.dart - entry point of the app

//dependencies
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agap/features/auth/pages/splashscreen.dart';
import 'package:agap/theme/color.dart';

//checks if supabase is configured
bool _isSupabaseConfigured = false;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await _initializeSupabaseIfConfigured();
  
  runApp(const MyApp());
}

// initialize supabase if env vars are present, otherwise skip to avoid runtime errors in dev/test environments without .env file
Future<void> _initializeSupabaseIfConfigured() async {

  //load env vars from .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint(' .env not found: $e');
    return;
  }

  //read supabase config from env vars
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  //debug log for verifying that env vars are loaded correctly
  debugPrint('SUPABASE_URL: $supabaseUrl');
  debugPrint('SUPABASE_ANON_KEY: ${supabaseAnonKey != null ? 'found' : 'missing'}');

  //validation: anon key and url are non-empty
  if (supabaseUrl == null || supabaseUrl.isEmpty ||
      supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
    
    debugPrint('Supabase env vars missing or empty, skipping init.');
    return;
  }

  //initialize supabase with config from .env
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  //set flag to true. supabase is successfully initialized
  _isSupabaseConfigured = true;
  debugPrint('Supabase initialized successfully.');
}


//root widget
//configures global theme and initial route
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.agapOrange,
          primary: AppColors.agapOrange,
        ),
        scaffoldBackgroundColor: AppColors.agapOrange,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
