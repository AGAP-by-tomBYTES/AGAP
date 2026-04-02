import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 205,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.agapNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LOGIN',
              style: AppTypography.buttonPrimary,
            ),
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: const BoxDecoration(
            //     color: Color(0x55FFFFFF),
            //     shape: BoxShape.circle,
            //   ),
            //   alignment: Alignment.center,
            //   child: const Icon(
            //     Icons.chevron_right_rounded,
            //     size: 28,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
