import 'package:flutter/material.dart';

import 'package:agap/features/auth/widgets/splash_logo.dart';
import 'package:agap/theme/color.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.roleLabel,
  });

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 315,
          decoration: const BoxDecoration(
            color: AppColors.agapOrange,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(280, 110),
            ),
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 28),
                const SplashLogo(),
                const SizedBox(height: 10),
                Text(
                  'Alert. Guide. Assist. Protect.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB8A1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    roleLabel,
                    style: const TextStyle(
                      color: AppColors.agapDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
