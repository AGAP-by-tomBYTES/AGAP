import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';

import 'package:agap/features/resident/pages/resident_dashboard.dart';
import 'package:agap/features/resident/pages/family_members.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:agap/features/resident/pages/send_sos.dart';

class ResidentBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Map<String, dynamic>? resident;

  const ResidentBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.resident,
  });

  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResidentDashboardPage()),
            );
          }),

          _navItem(context, Icons.call, 1, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmergencyHotlinesPage(resident: resident),
              ),
            );
          }),

          _buildCenterSosButton(context),

          _navItem(context, Icons.family_restroom_outlined, 3, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FamilyPage(resident: resident),
              ),
            );
          }),

          _navItem(context, Icons.person_outline, 4, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(resident: resident),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCenterSosButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SosPage(resident: resident)),
        );
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.agapOrangeAlt,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.agapCoral, width: 3),
        ),
        child: const Center(
          child: Text(
            "SOS",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index, VoidCallback onTap) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 28,
        color: isActive ? AppColors.agapCoral : Colors.black,
      ),
    );
  }
}