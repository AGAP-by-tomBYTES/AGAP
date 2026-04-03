import 'package:agap/core/routes/screen_routes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/features/auth/providers/auth_provider.dart';
import 'package:agap/features/auth/providers/auth_notifier.dart';

import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/features/auth/widgets/login_button.dart';
import 'package:agap/features/auth/widgets/login_header.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
  }

  void _loadRememberedUser() {
    final box = Hive.box("app_cache");
    final email = box.get("remember_email");

    if (email != null) {
      _emailController.text = email;
      _rememberMe = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const LoginHeader(roleLabel: "Login"),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// EMAIL
                      SignupField(
                        label: "Email",
                        hint: "Enter your email",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return "Invalid email format";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      /// PASSWORD
                      SignupField(
                        label: "Password",
                        controller: _passwordController,
                        obscureText: _isPasswordHidden,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// REMEMBER ME
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text("Remember Me"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// LOGIN BUTTON
                      LoginButton(
                        isLoading: _isLoading,
                        onPressed:
                            _isLoading ? null : () => _handleLogin(),
                      ),

                      const SizedBox(height: 20),

                      /// SIGNUP LINK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              context.go(Routes.signup);
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      /// REMEMBER ME
      final box = Hive.box("app_cache");
      if (_rememberMe) {
        box.put("remember_email", _emailController.text.trim());
      } else {
        box.delete("remember_email");
      }

      await ref.read(authNotifierProvider.notifier).refresh();

      if (!mounted) return;

      context.go(Routes.splash);

    } catch (e) {
      final message = _mapError(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _mapError(String error) {
    if (error.contains("Invalid login credentials")) {
      return "Wrong email or password";
    } else if (error.contains("Email not confirmed")) {
      return "Please verify your email first";
    }
    return "Login failed. Try again.";
  }
}