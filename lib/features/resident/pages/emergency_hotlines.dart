import 'package:agap/features/resident/pages/family_members.dart';
import 'package:agap/features/resident/pages/res_dashboard.dart';
import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/features/resident/pages/send_sos.dart';

class EmergencyHotlinesPage extends StatefulWidget {
  const EmergencyHotlinesPage({super.key});

  @override
  State<EmergencyHotlinesPage> createState() => _EmergencyHotlinesPageState();
}

class _EmergencyHotlinesPageState extends State<EmergencyHotlinesPage> {
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 25),
              decoration: BoxDecoration(
                color: AppColors.agapOrangeDeep,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi, Eleah',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Philadelphia St., Bagumbayan, Iloilo, PH',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none_outlined,
                      color: Colors.white, size: 28),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Miagao Emergency Contacts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildContactCard(
                    "MDRRMO",
                    "(Municipal Risk Reduction Management Office)",
                    landline: "332-4726",
                    globe: "09544829006",
                    smart: "09639866435",
                    email: "mdrrmomiagao.20@gmail.com",
                    color: Colors.blue.shade900,
                  ),
                  _buildContactCard(
                    "Miagao BFP",
                    "(Bureau of Fire Protection)",
                    landline: "315-2270",
                    smart: "09120833826",
                    color: Colors.indigo.shade700,
                  ),
                  _buildContactCard(
                    "Miagao PNP",
                    "(Philippine National Police)",
                    landline: "327-0079 / 327-8612",
                    smart: "09985986217",
                    color: Colors.indigo.shade700,
                  ),
                  const SizedBox(height: 100), // Space for bottom bar visibility
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(String title, String sub,
      {required String landline, String? globe, String? smart, String? email, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(sub, style: const TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic)),
            const Divider(height: 24),
            _infoRow(Icons.phone, "Landline", landline),
            if (globe != null) _infoRow(Icons.smartphone, "Globe", globe),
            if (smart != null) _infoRow(Icons.smartphone, "Smart", smart),
            if (email != null) _infoRow(Icons.email, "Email", email),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String val) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(val)),
          ],
        ),
      );

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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ResidentDashboardPage()),
              );;
          }),
          _navItem(Icons.call, 1, () {}),
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
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosPage())),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.agapOrangeAlt,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.agapCoral, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: const Center(child: Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        onTap();
      },
      child: Icon(icon, size: 28, color: isActive ? AppColors.agapCoral : Colors.black),
    );
  }

  
}