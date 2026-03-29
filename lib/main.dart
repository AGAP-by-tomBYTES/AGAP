import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agap/features/auth/pages/splashscreen.dart';

//brand colors
const _agapOrange = Color(0xFFF05C33);
bool _isSupabaseConfigured = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSupabaseIfConfigured();
  runApp(const MyApp());
}
// initialize supabase if env vars are present, otherwise skip to avoid runtime errors in dev/test environments without .env file
Future<void> _initializeSupabaseIfConfigured() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    return;
  }
// check if required env vars are present and non-empty before initializing Supabase
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
// If either is missing or empty, skip initialization
  if (supabaseUrl == null ||
      supabaseUrl.isEmpty ||
      supabaseAnonKey == null ||
      supabaseAnonKey.isEmpty) {
    return;
  }
// Initialize Supabase with the provided URL and anon key
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  _isSupabaseConfigured = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _agapOrange,
          primary: _agapOrange,
        ),
        scaffoldBackgroundColor: _agapOrange,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
