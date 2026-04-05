import 'package:flutter/material.dart';
// import 'package:agap/theme/theme.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';
import 'package:agap/features/resident/widgets/resident_header.dart';

class EmergencyHotlinesPage extends StatefulWidget {
  final Map<String, dynamic>? resident;

  const EmergencyHotlinesPage({super.key, required this.resident});

  @override
  State<EmergencyHotlinesPage> createState() => _EmergencyHotlinesPageState();
}

class _EmergencyHotlinesPageState extends State<EmergencyHotlinesPage> {
  final int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: ResidentBottomNavBar(
        selectedIndex: _selectedIndex,
        resident: widget.resident,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResidentHeader(resident: widget.resident, isLoading: false),

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
            color: Colors.black.withValues(alpha: 0.08),
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
}