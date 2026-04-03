import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agap/features/auth/providers/auth_provider.dart';
import 'package:agap/features/auth/providers/auth_notifier.dart';

class VerifyPage extends ConsumerWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final auth = ref.watch(authNotifierProvider);
    final service = ref.read(authServiceProvider);

    final user = service.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Please verify your email before continuing."),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await service.resendVerificationEmail(user!.email!);
              },
              child: const Text("Resend Email"),
            ),

            ElevatedButton(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).refresh();
              },
              child: const Text("I have verified"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}