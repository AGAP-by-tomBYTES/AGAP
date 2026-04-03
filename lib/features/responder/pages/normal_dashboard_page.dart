import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/pages/alerts_page.dart';
import 'package:agap/features/responder/pages/profile_page.dart';
import 'package:agap/features/responder/widgets/dashboard_section_card.dart';
import 'package:agap/theme/color.dart';

class ResponderNormalDashboardPage extends StatelessWidget {
  const ResponderNormalDashboardPage({
    super.key,
    required this.data,
  });

  final ResponderDashboardData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.profileHeader,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ResponderProfilePage(data: data),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.profile.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.profile.teamAndStationLabel,
                          style: const TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ResponderAlertsPage(data: data),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white12,
                        minimumSize: const Size(42, 42),
                      ),
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 26),
                child: Column(
                  children: [
                    DashboardSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ACTIVE ALERTS TODAY',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Alert totals will appear here once live responder dashboard data is connected.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TEAM & STATION',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InfoRow(label: 'Team', value: data.teamStation.team),
                          const SizedBox(height: 10),
                          _InfoRow(
                            label: 'Station',
                            value: data.teamStation.station,
                          ),
                        ],
                      ),
                    ),
                    if (data.weatherAdvisory != null) ...[
                      const SizedBox(height: 16),
                      _WeatherAdvisoryCard(data: data.weatherAdvisory!),
                    ],
                    const SizedBox(height: 16),
                    DashboardSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RECENT RESOLVED ALERTS',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Recent resolved incidents will appear here once responder activity is connected.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherAdvisoryCard extends StatelessWidget {
  const _WeatherAdvisoryCard({
    required this.data,
  });

  final WeatherAdvisoryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.warning, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.warning,
            child: Icon(Icons.priority_high, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF7F5200),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.message,
                  style: const TextStyle(
                    color: Color(0xFF805B14),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
