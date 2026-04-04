import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/pages/family_members.dart';
import 'package:agap/features/resident/pages/res_dashboard.dart';
import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';
import 'danger_page.dart';

class SafePage extends StatelessWidget {
  const SafePage({super.key});

  final int _selectedIndex = 2; // Keeps the SOS button active

  @override
  Widget build(BuildContext context) {
    const Color safeColor = Color(0xFF12B76A);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(context),
      body: Column(
        children: [
          /// 🛰️ TOP GREEN BAR (Custom Status Bar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 12), // Added top padding for notch
            color: safeColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "EMERGENCY ALERT ACTIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Since 8:15 AM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// SUCCESS CIRCLE
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: safeColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: safeColor.withOpacity(0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 70,
                      color: safeColor,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "You’re safe,\nEleah.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Your household and responders\nhave been notified.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "8:54 AM · Miagao, Iloilo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          /// UNDO BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE2E1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DangerPage()),
                  );
                },
                child: const Text(
                  "UNDO SAFE.\nI AM IN DANGER NOW.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔻 SHARED BOTTOM NAV BAR
  Widget _buildBottomBar(BuildContext context) {
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
          _navItem(context, Icons.home, 0, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResidentDashboardPage()),
            );
          }),
          _navItem(context, Icons.call, 1, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyHotlinesPage()),
            );
          }),
          _buildCenterSosButton(),
          _navItem(context, Icons.family_restroom_outlined, 3, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyPage()));
          }),
          _navItem(context, Icons.person_outline, 4, () {
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
        border: Border.all(
          color: AppColors.agapCoral.withOpacity(1),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: const Center(
        child: Text(
          "SOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index, VoidCallback onTap) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 30,
        color: isActive ? AppColors.agapCoral : Colors.black87,
      ),
    );
  }
}