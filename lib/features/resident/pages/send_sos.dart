import 'package:flutter/material.dart';
import 'package:agap/features/services/models/alert_type.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';
import 'package:agap/features/resident/pages/sos_confirmation_page.dart';
import 'package:intl/intl.dart';

class SosPage extends StatefulWidget {
  final Map<String, dynamic>? resident;

  const SosPage({super.key, required this.resident});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  final int _selectedIndex = 2;
  late final DateTime now;
  late final String formattedTime;

  @override
  void initState() {
    super.initState();
    // Initialize time once when the page loads
    now = DateTime.now();
    formattedTime = DateFormat('hh:mm a').format(now);
  }

  Widget _buildEmergencyPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.agapCoral.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your emergency?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.agapCoral,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pick the emergency category that best matches your situation.',
            style: TextStyle(
              color: Colors.black54,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 18),
          for (final option in AlertTypes.emergencyOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.agapCoral,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    side: BorderSide(
                      color: AppColors.agapCoral.withValues(alpha: 0.25),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SosConfirmationPage(
                          alertType: option.code,
                          resident: widget.resident,
                        ),
                      ),
                    );
                  },
                  child: Text(option.label),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ResidentBottomNavBar(
          selectedIndex: _selectedIndex, resident: widget.resident),
      body: Column(
        children: [
          ColoredBox(
            color: Colors.black,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "EMERGENCY ALERT",
                      style: TextStyle(
                        color: AppColors.agapOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Since $formattedTime",
                      style: const TextStyle(
                        color: AppColors.agapOrange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Are you\nsafe?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 64,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ), // Added missing comma
                  const SizedBox(height: 44),
                  _buildEmergencyPanel(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}