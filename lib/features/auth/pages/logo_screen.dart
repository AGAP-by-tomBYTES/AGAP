import 'package:flutter/material.dart';

import 'package:agap/features/auth/widgets/splash_logo.dart';
import 'package:agap/features/auth/services/auth_redirect_service.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {

  final _redirectService = AuthRedirectService();

  @override
  void initState() {
    super.initState();
    debugPrint("LogoScreen: initState called");
    _redirectService.handleAuthRedirect(mounted: mounted);
  }
  
  @override
  Widget build(BuildContext context) {
    debugPrint("LogoScreen: build() called");
    
    return const Scaffold(
      body: Center(child: SplashLogo()),
    );
  }
}