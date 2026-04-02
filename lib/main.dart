import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agap/features/responder/pages/emergency_dashboard_page.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';
import 'package:agap/theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSupabaseIfConfigured();
  runApp(const MyApp());
}
// initialize supabase if env vars are present, otherwise skip to avoid runtime errors in dev/test environments without .env file
Future<void> _initializeSupabaseIfConfigured() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint(' .env not found: $e');
    return;
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  debugPrint('SUPABASE_URL: $supabaseUrl');
  debugPrint('SUPABASE_ANON_KEY: ${supabaseAnonKey != null ? 'found' : 'missing'}');

  if (supabaseUrl == null ||
      supabaseUrl.isEmpty ||
      supabaseAnonKey == null ||
      supabaseAnonKey.isEmpty) {
    debugPrint('Supabase env vars missing or empty, skipping init.');
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  debugPrint('Supabase initialized successfully.');
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
          seedColor: AppColors.agapOrange,
          primary: AppColors.agapOrange,
        ),
        scaffoldBackgroundColor: AppColors.agapOrange,
        useMaterial3: true,
      ),
      home: const ResponderEmergencyDashboardPage(
        data: responderDashboardPreviewData,
      ),
    );
  }
}
