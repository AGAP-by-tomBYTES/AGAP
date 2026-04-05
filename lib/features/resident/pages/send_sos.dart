import 'dart:async';
import 'package:agap/features/resident/pages/safe_state.dart';
import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'danger_page.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';


class SosPage extends StatefulWidget {
  final Map<String, dynamic>? resident;

  const SosPage({super.key, required this.resident});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  double progress = 0.0;
  Timer? _timer;
  final int _selectedIndex = 2;

  void _startHolding() {
    progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.02;
        if (progress >= 1) {
          timer.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SafePage()),
          );
        }
      });
    });
  }

  void _stopHolding() {
    _timer?.cancel();
    setState(() {
      progress = 0.0;
    });
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
        resident: widget.resident
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 30, 12, 12), 
            color: Colors.black,
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  const Text(
                    'TYPHOON ESTHER · SIGNAL NO. 3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DangerPage())),
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
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
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
                              )
                            ],
                          ),
                          child: Center(
                            child: progress > 0
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
                                          text: "SAFE",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: "\nTap for ",
                                            style: TextStyle(color: AppColors.agapCoral.withValues(alpha: 0.8))),
                                        const TextSpan(
                                          text: "DANGER",
                                          style: TextStyle(
                                            color: AppColors.agapCoral,
                                            fontWeight: FontWeight.bold,
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