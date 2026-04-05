import 'package:agap/features/auth/widgets/signup_field.dart';
// import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';
import 'resident_signup_medical.dart';

class ResidentSignupHouseholdPage extends StatefulWidget {
  final ResidentData data;

  const ResidentSignupHouseholdPage({super.key, required this.data});

  @override
  State<ResidentSignupHouseholdPage> createState() =>
      _ResidentSignupHouseholdPageState();
}

class _ResidentSignupHouseholdPageState
    extends State<ResidentSignupHouseholdPage> {

  final _pets = TextEditingController();

  int householdSize = 1;
  int children = 0;
  int elderly = 0;
  int disabled = 0;

  @override
  void initState() {
    super.initState();

    debugPrint("Household page initialized with received data");
    debugPrint(widget.data.toJson().toString());

    householdSize = widget.data.householdSize;
    children = widget.data.children;
    elderly = widget.data.elderly;
    disabled = widget.data.disabled;

    _pets.text = widget.data.pets ?? '';
  }

  @override
  void dispose() {
    _pets.dispose();
    super.dispose();
  }

  void _next() {
    debugPrint("User tapped continue on household step");

    final updatedData = ResidentData(
      email: widget.data.email,
      password: widget.data.password,
      firstName: widget.data.firstName,
      middleName: widget.data.middleName,
      lastName: widget.data.lastName,
      suffix: widget.data.suffix,
      phone: widget.data.phone,
      birthdate: widget.data.birthdate,
      sex: widget.data.sex,

      houseNo: widget.data.houseNo,
      street: widget.data.street,
      barangay: widget.data.barangay,
      municipality: widget.data.municipality,
      city: widget.data.city,
      province: widget.data.province,
      region: widget.data.region,
      postalCode: widget.data.postalCode,
      landmark: widget.data.landmark,

      householdSize: householdSize,
      children: children,
      elderly: elderly,
      disabled: disabled,
      pets: _pets.text.trim().isEmpty ? null : _pets.text.trim(),

      conditions: widget.data.conditions,
      history: widget.data.history,
      allergies: widget.data.allergies,
      medications: widget.data.medications,
    );

    debugPrint("Updated ResidentData after household step");
    debugPrint(updatedData.toJson().toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupMedicalPage(data: updatedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SignupStepHeader(
              stepLabel: 'STEP 3 OF 5',
              sectionLabel: 'HOUSEHOLD',
              title: 'Your Household',
              description:
                  'Helps responders plan resources and prioritize vulnerable members.',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _CounterCard(
                    label: "Household Size",
                    value: householdSize,
                    onChanged: (v) => setState(() => householdSize = v),
                  ),
                  const SizedBox(height: 14),
                  _CounterCard(
                    label: "Children",
                    value: children,
                    onChanged: (v) => setState(() => children = v),
                  ),
                  const SizedBox(height: 14),
                  _CounterCard(
                    label: "Elderly",
                    value: elderly,
                    onChanged: (v) => setState(() => elderly = v),
                  ),
                  const SizedBox(height: 14),
                  _CounterCard(
                    label: "Persons with Disability",
                    value: disabled,
                    onChanged: (v) => setState(() => disabled = v),
                  ),
                  const SizedBox(height: 14),
                  SignupField(
                    label: 'Pets (optional)',
                    hint: 'e.g.: dog, cat, etc.',
                    controller: _pets,
                    keyboardType: TextInputType.text,
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("BACK"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _next,
                          child: const Text("CONTINUE"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const _CounterCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  void _decrement() {
    if (value > 0) onChanged(value - 1);
  }

  void _increment() {
    onChanged(value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(onPressed: _decrement, icon: const Icon(Icons.remove)),
            Text("$value"),
            IconButton(onPressed: _increment, icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}