import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/AGAP_logolight.png',
      width: 190,
      fit: BoxFit.contain,
    );
  }
}
