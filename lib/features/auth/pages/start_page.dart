import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/features/auth/widgets/get_started_button.dart';
import 'package:agap/features/auth/widgets/splash_logo.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 4),

              const SplashLogo(),

              const SizedBox(height: 20),

              Text(
                'Alert. Guide. Assist. Protect.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
              ),

              const Spacer(flex: 5),

              GetStartedButton(
                onPressed: () {
                  context.go(Routes.role);
                },
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}