import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/features/auth/providers/auth_notifier.dart';
import 'package:agap/features/auth/widgets/splash_logo.dart';
import 'package:agap/core/routes/screen_routes.dart';

class LogoScreen extends ConsumerStatefulWidget {
  const LogoScreen({super.key});

  @override
  ConsumerState<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends ConsumerState<LogoScreen> {

  @override
  void initState() {
    super.initState();

    final auth = ref.read(authNotifierProvider);

    if (auth.isLoggedIn) {
      Future.microtask((){
        if (!mounted) return;

        if (!auth.isVerified) {
          context.go(auth.isResponder ? Routes.responder : Routes.resident);
        }
      });

      return;
    }

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      context.go(Routes.start);
    });
  }

  @override
  Widget build(BuildContext context) {
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