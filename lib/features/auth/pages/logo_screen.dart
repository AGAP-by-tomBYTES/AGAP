import 'package:flutter/material.dart';

import 'package:agap/features/auth/widgets/splash_logo.dart';
import 'package:agap/features/auth/services/auth_redirect_service.dart';

//display app logo on launch if not logged in
//handle auth redirect logic
class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {

  //auth redirect helper
  final _redirectService = AuthRedirectService();

  @override
  void initState() {
    super.initState();
    debugPrint("LogoScreen: initState called");
    _redirectService.handleAuthRedirect(mounted: mounted);
    debugPrint("LogoScreen: auth redirect called");
  }
  
  @override
  Widget build(BuildContext context) {
    debugPrint("LogoScreen: build() called");
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SplashLogo(),
            SizedBox(height: 20),
            Text(
                'Alert. Guide. Assist. Protect.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
            ),
          ],
        ),
      ),
    );
  }
}