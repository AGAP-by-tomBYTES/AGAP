import 'dart:async';

import 'package:flutter/material.dart';
import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';
import 'package:agap/features/responder/data/responder_repository.dart';
import 'package:agap/features/responder/pages/normal_dashboard_page.dart';

class ResponderTestPage extends StatefulWidget {
  const ResponderTestPage({super.key});

  @override
  State<ResponderTestPage> createState() => _ResponderTestPageState();
}

class _ResponderTestPageState extends State<ResponderTestPage> {
  final _repository = ResponderRepository();
  Map<String, dynamic>? _responder;
  bool _loading = true;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _loadResponder();
  }

  Future<void> _loadResponder() async {
    final data = await _repository.getCurrentResponder();
    if (!mounted) return;

    setState(() {
      _responder = data;
      _loading = false;
    });

    if (data != null) {
      final dashboardData = _buildDashboardData(data);
      _redirectTimer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ResponderNormalDashboardPage(data: dashboardData),
          ),
        );
      });
    }
  }

  Future<void> _signOut() async {
    _redirectTimer?.cancel();
    await _repository.signOut();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responder Test Page')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _responder == null
              ? const Center(child: Text('No responder data found.'))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile created successfully!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Redirecting to dashboard in a few seconds...',
                      ),
                      const SizedBox(height: 24),
                      _row('Name',
                          '${_responder!['first_name']} ${_responder!['last_name']}'),
                      _row('Email', _responder!['email']),
                      _row('Phone', _responder!['phone']),
                      _row('Employee ID', _responder!['employee_id_number']),
                      _row('Role', _responder!['responder_role']),
                      _row('Created at', _responder!['created_at']),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _signOut,
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value ?? '—')),
        ],
      ),
    );
  }
}
