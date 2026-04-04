import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
  });

  final String promptText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: promptText),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  actionText,
                  style: AppTypography.buttonLink.copyWith(
                    color: AppColors.agapOrangeDeep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
