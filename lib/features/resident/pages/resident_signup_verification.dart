import 'package:flutter/material.dart';

class ResidentSignupVerificationPage extends StatelessWidget {
  const ResidentSignupVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: const Center(
        child: Text(
          'Check your email to verify your account.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}