import 'package:flutter/material.dart';
import 'package:agap/theme/theme.dart';

class ResidentHeader extends StatelessWidget {
  final Map<String, dynamic>? resident;
  final bool isLoading;

  const ResidentHeader({
    super.key,
    required this.resident,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 25),
      decoration: BoxDecoration(
        color: AppColors.agapOrangeDeep,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoading
                    ? 'Loading...'
                    : 'Hi, ${resident?['first_name'] ?? 'User'}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isLoading
                    ? ''
                    : '${resident?['street'] ?? ''}, ${resident?['barangay'] ?? ''}, ${resident?['city'] ?? ''}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }
}