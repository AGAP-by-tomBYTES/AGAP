import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';

class RoleScreenFooter extends StatelessWidget {
  const RoleScreenFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/AGAP_logo.png',
            width: 92,
            fit: BoxFit.contain,
          ),
          Text(
            'Developed by TOMBytes for Miagao MDRRMO',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.agapDark.withValues(alpha: 0.72),
              fontSize: 8,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
