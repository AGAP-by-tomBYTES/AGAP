import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agap/features/auth/providers/auth_notifier.dart';
import 'package:agap/features/auth/widgets/splash_logo.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ///debugging
    debugPrint(
      "Splash → loading=${authState.isLoading}, "
      "loggedIn=${authState.isLoggedIn}, "
      "verified=${authState.isVerified}, "
      "responder=${authState.isResponder}",
    );

    return const Scaffold(
      body: Center(
        child: SplashLogo(),
      ),
    );
  }
}