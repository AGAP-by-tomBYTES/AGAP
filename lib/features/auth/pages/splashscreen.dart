import 'package:flutter/material.dart';

import 'package:agap/config/app_config.dart';
import 'package:agap/features/auth/pages/rolescreen.dart';
import 'package:agap/features/auth/widgets/get_started_button.dart';
import 'package:agap/features/auth/widgets/splash_logo.dart';
import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';
import 'package:agap/features/responder/data/responder_repository.dart';
import 'package:agap/features/responder/pages/normal_dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _repository = ResponderRepository();
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _restoreSessionIfAvailable();
  }

  Future<void> _restoreSessionIfAvailable() async {
    if (!AppConfig.isSupabaseConfigured) {
      if (!mounted) return;
      setState(() {
        _checkingSession = false;
      });
      return;
    }

    try {
      final responder = await _repository.getCurrentResponder();
      if (!mounted) return;

      if (responder != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ResponderNormalDashboardPage(
              data: _buildDashboardData(responder),
            ),
          ),
        );
        return;
      }
    } catch (_) {
      // Fall back to the splash CTA if session restore fails.
    }

    if (!mounted) return;
    setState(() {
      _checkingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 4),
              const SplashLogo(),
              const SizedBox(height: 20),
              Text(
                'Alert. Guide. Assist. Protect.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(flex: 5),
              if (_checkingSession)
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              else
                GetStartedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RoleScreen(),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  ResponderDashboardData _buildDashboardData(Map<String, dynamic> responder) {
    final firstName = responder['first_name'] as String? ?? '';
    final lastName = responder['last_name'] as String? ?? '';
    final role = responder['responder_role'] as String? ?? 'Responder';
    final employeeId =
        responder['employee_id_number'] as String? ?? 'Not assigned';
    final fullName = [firstName, lastName]
        .where((part) => part.trim().isNotEmpty)
        .join(' ')
        .trim();

    return ResponderDashboardData(
      profile: ResponderProfileData(
        name: fullName.isEmpty ? 'Responder' : fullName,
        teamAndStationLabel: '$role • $employeeId',
      ),
      alertSummary: responderDashboardPreviewData.alertSummary,
      teamStation: responderDashboardPreviewData.teamStation,
      weatherAdvisory: responderDashboardPreviewData.weatherAdvisory,
      resolvedAlerts: responderDashboardPreviewData.resolvedAlerts,
      emergencyDispatch: responderDashboardPreviewData.emergencyDispatch,
    );
  }
}
