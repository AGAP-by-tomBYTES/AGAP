import 'dart:async';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/pages/family_members.dart';
import 'package:agap/features/resident/pages/res_dashboard.dart';
import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:agap/features/resident/pages/safe_state.dart';
import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'danger_page.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

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
      bottomNavigationBar: _buildBottomBar(),
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

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home, 0, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ResidentDashboardPage()));
          }),
          _navItem(Icons.call, 1, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyHotlinesPage()));
          }),
          _buildCenterSosButton(),
          _navItem(Icons.family_restroom_outlined, 3, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyPage()));
          }),
          _navItem(Icons.person_outline, 4, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilePage()),
              );
          }),
        ],
      ),
    );
  }

  Widget _buildCenterSosButton() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.agapOrangeAlt,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.agapCoral, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: const Center(
        child: Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 30, color: isActive ? AppColors.agapCoral : Colors.black87),
    );
  }
}