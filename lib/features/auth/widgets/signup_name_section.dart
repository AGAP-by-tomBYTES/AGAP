import 'package:flutter/material.dart';
import 'signup_field.dart';

class SignupNameSection extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController middleName;
  final TextEditingController lastName;
  final TextEditingController suffix;

  const SignupNameSection({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
  });

  String? _required(String? v) =>
      v == null || v.isEmpty ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SignupField(
                label: 'First name',
                controller: firstName,
                validator: _required,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SignupField(
                label: 'Last name',
                controller: lastName,
                validator: _required,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SignupField(
                label: 'Middle name',
                controller: middleName,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SignupField(
                label: 'Suffix',
                controller: suffix,
              ),
            ),
          ],
        ),
      ],
    );
  }
}