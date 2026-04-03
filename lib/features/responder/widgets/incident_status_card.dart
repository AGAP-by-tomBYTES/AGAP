import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

enum IncidentProgressStatus {
  enRoute,
  arrived,
  resolved,
}

class IncidentStatusCard extends StatelessWidget {
  const IncidentStatusCard({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final IncidentStatusData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(data.status);
    final helperText = _helperText(data.status);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: config.badgeColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Colors.white, size: 12),
                const SizedBox(width: 10),
                Text(
                  data.badgeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: config.bannerColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.navigation_rounded, color: Colors.black, size: 28),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    data.timestampText,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.60),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: config.buttonColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(68),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.actionLabel,
                    style: AppTypography.buttonStatus,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    helperText,
                    style: const TextStyle(
                      color: Color(0xE6FFFFFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _IncidentStatusConfig _statusConfig(IncidentProgressStatus status) {
    switch (status) {
      case IncidentProgressStatus.enRoute:
        return const _IncidentStatusConfig(
          badgeColor: AppColors.agapOrangeDeep,
          bannerColor: AppColors.liveOrangeSoft,
          buttonColor: AppColors.liveOrange,
        );
      case IncidentProgressStatus.arrived:
        return const _IncidentStatusConfig(
          badgeColor: AppColors.infoBlue,
          bannerColor: AppColors.infoBlueSoft,
          buttonColor: AppColors.infoBlue,
        );
      case IncidentProgressStatus.resolved:
        return const _IncidentStatusConfig(
          badgeColor: AppColors.success,
          bannerColor: AppColors.successSoft,
          buttonColor: AppColors.success,
        );
    }
  }

  String _helperText(IncidentProgressStatus status) {
    switch (status) {
      case IncidentProgressStatus.enRoute:
        return 'Tap to mark that you have arrived on scene';
      case IncidentProgressStatus.arrived:
        return 'Tap to continue to the incident report';
      case IncidentProgressStatus.resolved:
        return 'Tap to return after closing this response';
    }
  }
}

class _IncidentStatusConfig {
  const _IncidentStatusConfig({
    required this.badgeColor,
    required this.bannerColor,
    required this.buttonColor,
  });

  final Color badgeColor;
  final Color bannerColor;
  final Color buttonColor;
}
