import 'package:agap/core/services/supabase_service.dart';
import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/widgets/dashboard_section_card.dart';
import 'package:agap/theme/color.dart';

class ResponderAlertsPage extends StatefulWidget {
  const ResponderAlertsPage({
    super.key,
    required this.data,
  });

  final ResponderDashboardData data;

  @override
  State<ResponderAlertsPage> createState() => _ResponderAlertsPageState();
}

class _ResponderAlertsPageState extends State<ResponderAlertsPage> {
  List<dynamic> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final client = SupabaseService.client;
    final alerts = await client
        .from('alerts')
        .select()
        .order('created_at', ascending: false);
    setState(() {
      _alerts = alerts;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Expanded(
                    child: Text(
                      'Responder Alerts',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.agapOrangeDeep, AppColors.agapOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ALERTS OVERVIEW',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.data.teamStation.station,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Incoming, active, and resolved alert activity will appear here once live responder alerts are connected.',
                      style: TextStyle(
                        color: Color(0xFFFFE2D6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DashboardSectionCard(
                child: _AlertSection(
                  title: 'ACTIVE ALERTS',
                  emptyTitle: 'No live alerts yet',
                  emptyMessage:
                      'Once resident SOS reports and incident data are connected, active responder alerts will appear in this section.',
                ),
              ),
              const SizedBox(height: 16),
              const DashboardSectionCard(
                child: _AlertSection(
                  title: 'ALERT HISTORY',
                  emptyTitle: 'No alert history yet',
                  emptyMessage:
                      'Resolved and archived incident history will be shown here after the backend alert pipeline is connected.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertSection extends StatelessWidget {
  const _AlertSection({
    required this.title,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final String title;
  final String emptyTitle;
  final String emptyMessage;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE7E2DB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.agapOrangeDeep,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emptyTitle,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      emptyMessage,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
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
    );
  }
}
