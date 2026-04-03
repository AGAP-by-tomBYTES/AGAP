import 'package:flutter/material.dart';
import 'signup_field.dart';

class SignupPasswordSection extends StatelessWidget {
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final bool hidePass;
  final bool hideConfirm;
  final VoidCallback onTogglePass;
  final VoidCallback onToggleConfirm;

  const SignupPasswordSection({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.hidePass,
    required this.hideConfirm,
    required this.onTogglePass,
    required this.onToggleConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignupField(
          label: 'Password',
          controller: password,
          obscureText: hidePass,
          suffixIcon: IconButton(
            icon: Icon(
              hidePass ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: onTogglePass,
          ),
        ),
        const SizedBox(height: 14),
        SignupField(
          label: 'Confirm Password',
          controller: confirmPassword,
          obscureText: hideConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              hideConfirm ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: onToggleConfirm,
          ),
        ),
      ],
    );
  }
}