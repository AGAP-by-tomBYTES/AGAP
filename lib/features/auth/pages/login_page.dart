//dependencies
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive/hive.dart';

import 'package:agap/theme/theme.dart';
import 'package:agap/features/auth/widgets/widgets.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/auth/user_role.dart';
import 'package:agap/core/services/navigation_service.dart';
import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/responder/data/responder_service.dart';
import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';


//login page
//email and password - supabase aligned auth
//role based navigation with error handling
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
  final _scrollController = ScrollController();


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
            LoginHeader(roleLabel: widget.role == UserRole.resident ? "Resident" : " Responder"),

            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(999),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EMAIL
                        SignupField(
                          label: "Email",
                          hint: "Enter your email",
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
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
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      //REMEMBER ME
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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

                          //Forgot Password
                          TextButton(
                            onPressed: () {
                              //TO DO()
                              // NavigationService.pushReplacement(Routes.forgotpassword);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppTypography.buttonLink.copyWith(
                                color: AppColors.agapOrangeDeep,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      //LOGIN Button
                      Center(
                        child: LoginButton(
                              isLoading: _isLoading,
                              onPressed: _isLoading ? null : _handleLogin,
                        ),
                      ),

                      const SizedBox(height: 18),

                      AuthSwitchPrompt(
                        promptText: "Don't have an account? ",
                        actionText: "Sign Up",
                        onTap: () {
                          debugPrint("LoginPage: Navigate to signup");

                          if (widget.role == UserRole.responder && !SupabaseService.isInitialized) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text (
                                  "Resident signup requires a .env file with Supabase keys.",
                                ),
                                behavior: SnackBarBehavior.floating
                              )
                            );
                            return;
                          }

                          if (widget.role == UserRole.resident) {
                            NavigationService.pushReplacement(Routes.residentSignupPage1, arguments: widget.role);
                          } else {
                            NavigationService.pushReplacement(Routes.responderSignupPage, arguments: widget.role);
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ),
            )
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

      //navigate based on role
      if (widget.role == UserRole.resident) {
        debugPrint("LoginPage: Navigating to /resident");
        NavigationService.pushReplacement(Routes.residentDashboard);
      } else {
        debugPrint("LoginPage: Navigating to /responder");

        final responderService = ResponderService();
        
        ResponderDashboardData data;
        
        try {
          data = await responderService.getDashboardData();
        } catch (e) {
          debugPrint("Fallback to preview data: $e");
          data = responderDashboardPreviewData;
        }

        if (!mounted) return;
        NavigationService.pushReplacement(Routes.responderDashboard,arguments: data);
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

  //login errors
  String _mapError(String error) {
    debugPrint("LoginPage: Mapping error -> $error");

    if (error.contains("Invalid login credentials")) {
      return "Wrong email or password";
    } else if (error.contains("Email not confirmed")) {
      return "Please verify your email first";
    } else if (error.contains("network")) {
      return "Network error. Check your internet connection.";
    } else if (error.contains("timeout")) {
      return "Login request timed out. Try again.";
    } else if (error.contains("supabase")) {
      return "Server error. Please try again later.";
    }
    return "Login failed. Try again.";
  }
}