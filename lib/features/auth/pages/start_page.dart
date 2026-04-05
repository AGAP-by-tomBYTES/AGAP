import 'package:flutter/material.dart';

import 'package:agap/features/auth/widgets/get_started_button.dart';
import 'package:agap/features/auth/widgets/splash_logo.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("StartPage: build() called");
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              const SplashLogo(),
              const Spacer(),

              GetStartedButton(
                onPressed: () {
                  debugPrint("StartPage: Get Started button pressed");
                  debugPrint("Navigating to /role");
                  Navigator.pushNamed(context, '/role');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}