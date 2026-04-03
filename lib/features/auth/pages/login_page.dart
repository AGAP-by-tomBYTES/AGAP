import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive/hive.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/features/auth/widgets/login_button.dart';
import 'package:agap/features/auth/widgets/login_header.dart';
import 'package:agap/features/auth/user_role.dart';
import 'package:agap/core/services/navigation_service.dart';
import 'package:agap/core/routes/screen_routes.dart';

class LoginPage extends StatefulWidget {
  final UserRole role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    debugPrint("LoginPage: initState called");
    _loadRememberedUser();
  }

  void _loadRememberedUser() {
    debugPrint("LoginPage: Loading remembered user");

    final box = Hive.box("app_cache");
    final email = box.get("remember_email");

    if (email != null) {
      debugPrint("LoginPage: Found remembered email");
      _emailController.text = email;
      _rememberMe = true;
    }
  }

  @override
  void dispose() {
    debugPrint("LoginPage: dispose called");
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("LoginPage: build() called with role: ${widget.role}");

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

                      // EMAIL
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

                      // PASSWORD
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
                            debugPrint("LoginPage: Toggle password visibility");
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

                      // REMEMBER ME
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              debugPrint("LoginPage: Remember me -> $val");
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text("Remember Me"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // LOGIN BUTTON
                      LoginButton(
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _handleLogin,
                      ),

                      const SizedBox(height: 20),

                      // SIGNUP LINK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              debugPrint("LoginPage: Navigate to signup");

                              NavigationService.pushReplacement(Routes.residentSignupPage1, arguments: widget.role);
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
    debugPrint("LoginPage: Login button pressed");

    if (!_formKey.currentState!.validate()) {
      debugPrint("LoginPage: Validation failed");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();

      debugPrint("LoginPage: Attempting sign in");

      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      debugPrint("LoginPage: Login successful");

      // REMEMBER ME
      final box = Hive.box("app_cache");
      if (_rememberMe) {
        debugPrint("LoginPage: Saving email");
        box.put("remember_email", _emailController.text.trim());
      } else {
        debugPrint("LoginPage: Removing saved email");
        box.delete("remember_email");
      }

      if (!mounted) {
        debugPrint("LoginPage: Not mounted, abort navigation");
        return;
      }

      // ROLE-BASED NAVIGATION
      if (widget.role == UserRole.resident) {
        debugPrint("LoginPage: Navigating to /resident");
        Navigator.pushReplacementNamed(context, '/residentDashboard');
      } else {
        debugPrint("LoginPage: Navigating to /responder");
        Navigator.pushReplacementNamed(context, '/responder');
      }

    } catch (e) {
      debugPrint("LoginPage: Error -> $e");

      final message = _mapError(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _mapError(String error) {
    debugPrint("LoginPage: Mapping error -> $error");

    if (error.contains("Invalid login credentials")) {
      return "Wrong email or password";
    } else if (error.contains("Email not confirmed")) {
      return "Please verify your email first";
    }
    return "Login failed. Try again.";
  }
}