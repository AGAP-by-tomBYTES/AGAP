import 'package:flutter/material.dart';
import 'package:agap/features/responder/data/responder_repository.dart';

class ResponderTestPage extends StatefulWidget {
  const ResponderTestPage({super.key});

  @override
  State<ResponderTestPage> createState() => _ResponderTestPageState();
}

class _ResponderTestPageState extends State<ResponderTestPage> {
  final _repository = ResponderRepository();
  Map<String, dynamic>? _responder;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadResponder();
  }

  Future<void> _loadResponder() async {
    final data = await _repository.getCurrentResponder();
    setState(() {
      _responder = data;
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
