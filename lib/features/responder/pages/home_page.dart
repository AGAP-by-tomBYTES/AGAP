import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/features/auth/providers/auth_notifier.dart';
import 'package:agap/core/routes/screen_routes.dart';

class ResponderHomePage extends ConsumerWidget {
  const ResponderHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final profile = authState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responder Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();

              if (!context.mounted) return;

              context.go(Routes.splash);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome, ${profile?.firstName ?? "Responder"}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}