import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.agapCoral,
          foregroundColor: AppColors.agapNavyAlt,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: const BorderSide(
              color: AppColors.overlayWhiteMedium,
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.agapNavyAlt,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const Text(
              '›››',
              style: TextStyle(
                color: AppColors.agapNavyAlt,
                fontSize: 30,
                fontWeight: FontWeight.w300,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
