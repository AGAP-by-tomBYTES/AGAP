import 'package:flutter/material.dart';
import '../data/resident_repository.dart';

class ResidentTestPage extends StatefulWidget {
  const ResidentTestPage({super.key});

  @override
  State<ResidentTestPage> createState() => _ResidentTestPageState();
}

class _ResidentTestPageState extends State<ResidentTestPage> {
  final _repository = ResidentRepository();
  Map<String, dynamic>? _resident;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadResident();
  }

  Future<void> _loadResident() async {
    final data = await _repository.getCurrentResident();
    setState(() {
      _resident = data;
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    await _repository.signOut();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resident Test Page')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _resident == null
              ? const Center(child: Text('No resident data found.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [

                      const Text(
                        'Profile created successfully!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ACCOUNT
                      _section("ACCOUNT", [
                        _row('Name',
                            '${_resident!['first_name'] ?? ''} ${_resident!['last_name'] ?? ''}'),
                        _row('Email', _resident!['email']),
                        _row('Phone', _resident!['phone']),
                      ]),

                      /// LOCATION
                      _section("LOCATION", [
                        _row('House No.', _resident!['house_no']),
                        _row('Street', _resident!['street']),
                        _row('Barangay', _resident!['barangay']),
                        _row('Municipality', _resident!['municipality']),
                        _row('City', _resident!['city']),
                        _row('Province', _resident!['province']),
                        _row('Zip Code', _resident!['postal_code']),
                        _row('Landmark', _resident!['landmark']),
                      ]),

                      /// HOUSEHOLD
                      _section("HOUSEHOLD", [
                        _row('Household Size', _resident!['household_size']),
                        _row('Children', _resident!['children']),
                        _row('Elderly', _resident!['elderly']),
                        _row('PWD', _resident!['disabled']),
                        _row('Pets', _resident!['pets']),
                      ]),

                      /// MEDICAL
                      _section("MEDICAL", [
                        _row('Conditions', _resident!['conditions']),
                        _row('History', _resident!['history']),
                        _row('Allergies', _resident!['allergies']),
                        _row('Medications', _resident!['medications']),
                      ]),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: _signOut,
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// SECTION WIDGET
  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  /// ROW WIDGET (SAFE)
  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value?.toString() ?? '—'),
          ),
        ],
      ),
    );
  }
}