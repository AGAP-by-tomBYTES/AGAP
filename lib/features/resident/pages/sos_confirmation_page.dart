import 'dart:async';

import 'package:agap/features/resident/pages/safe_state.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';
import 'package:agap/features/services/models/alert_type.dart';
import 'package:agap/features/services/sos_alert_service.dart';
import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';

import 'danger_page.dart';

class SosConfirmationPage extends StatefulWidget {
  const SosConfirmationPage({
    super.key,
    required this.alertType,
    required this.resident,
  });

  final String alertType;
  final Map<String, dynamic>? resident;

  @override
  State<SosConfirmationPage> createState() => _SosConfirmationPageState();
}

class _SosConfirmationPageState extends State<SosConfirmationPage> {
  double progress = 0.0;
  Timer? _timer;
  final int _selectedIndex = 2;
  bool _busy = false;
  bool _ignoreNextTap = false;

  void _startHolding() {
    if (_busy) return;

    progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final nextProgress = progress + 0.02;
      final reachedSafeThreshold = nextProgress >= 1;

      setState(() {
        progress = reachedSafeThreshold ? 1.0 : nextProgress;
        if (reachedSafeThreshold) {
          _ignoreNextTap = true;
        }
      });

      if (reachedSafeThreshold) {
        timer.cancel();
        _reportSafe();
      }
    });
  }

  void _stopHolding() {
    _timer?.cancel();
    if (_ignoreNextTap || !mounted) return;

    setState(() {
      progress = 0.0;
    });
  }

  Future<void> _reportSafe() async {
    if (_busy) return;

    setState(() {
      _busy = true;
    });

    try {
      await SosAlertService.sendAlert(AlertTypes.safe);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SafePage()),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _ignoreNextTap = false;
          progress = 0.0;
        });
      }
    }
  }

  Future<void> _sendDangerAlert() async {
    if (_busy) return;

    setState(() {
      _busy = true;
    });

    try {
      await SosAlertService.sendAlert(widget.alertType);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DangerPage(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _ignoreNextTap = false;
          progress = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ResidentBottomNavBar(
        selectedIndex: _selectedIndex,
        resident: widget.resident,
      ),
      body: Column(
        children: [
          ColoredBox(
            color: Colors.black,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "EMERGENCY ALERT ACTIVE",
                      style: TextStyle(
                        color: AppColors.agapOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Since 8:15 AM",
                      style: TextStyle(
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
                  ),
                  const SizedBox(height: 170),
                  GestureDetector(
                    onTap: _busy ? null : _sendDangerAlert,
                    onTapDown: (_) => _startHolding(),
                    onTapUp: (_) => _stopHolding(),
                    onTapCancel: _stopHolding,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: _busy
                                ? const Text(
                                    "Sending alert...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : progress > 0
                                ? const Text(
                                    "Keep holding... \n Marking you safe",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        const TextSpan(text: "Hold for "),
                                        const TextSpan(
                                          text: "safe",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "\ntap for danger",
                                          style: TextStyle(
                                            color: AppColors.agapCoral.withValues(
                                              alpha: 0.85,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
