import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/features/auth/user_role.dart';
import 'package:agap/features/auth/providers/role_provider.dart';

import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/features/auth/providers/auth_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _lastName = TextEditingController();

  bool _loading = false;

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  @override
  Widget build(BuildContext context) {
    final selectedRole = ref.watch(selectedRoleProvider);

    if (selectedRole == null) {
      return const Scaffold(
        body: Center(child: Text("Please select a role first")),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(selectedRole == UserRole.responder ? "Sign Up as Responder" : "Sign Up as Resident")),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SignupField(
                label: "Email",
                controller: _email,
                validator: (value) {
                  if (!emailRegex.hasMatch(value ?? "")) {
                    return "Invalid email format";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              SignupField(
                label: "Password",
                controller: _password,
                obscureText: true,
              ),

              const SizedBox(height: 12),

              SignupField(
                label: "First Name",
                controller: _firstName,
              ),

              const SizedBox(height: 12),

              SignupField(
                label: "Middle Name",
                controller: _middleName,
              ),

              const SizedBox(height: 12),

              SignupField(
                label: "Last Name",
                controller: _lastName,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: const Text("Create Account"),
              ),

              TextButton(
                onPressed: () => context.go(Routes.login),
                child: const Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final auth = ref.read(authServiceProvider);
      final role = ref.read(selectedRoleProvider);

      final isResponder = role == UserRole.responder;

      await auth.signUpWithProfile(
        email: _email.text.trim(),
        password: _password.text.trim(),
        firstName: _firstName.text.trim(),
        middleName: _middleName.text.trim(),
        lastName: _lastName.text.trim(),
        gender: "N/A",
        address: "N/A",
        isResponder: isResponder,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful! Verify email.")),
      );

      context.go(Routes.login);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}