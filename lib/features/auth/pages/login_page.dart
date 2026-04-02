import 'package:flutter/material.dart';

import 'package:agap/features/auth/pages/forgot_password_page.dart';
import 'package:agap/features/auth/widgets/login_button.dart';
import 'package:agap/features/auth/widgets/login_header.dart';
import 'package:agap/features/responder/pages/signup.dart';
import 'package:agap/features/responder/widgets/auth_switch_prompt.dart';
import 'package:agap/features/responder/widgets/signup_field.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.roleLabel,
    required this.idLabel,
    required this.idHint,
  });

  final String roleLabel;
  final String idLabel;
  final String idHint;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _scrollController.dispose();
    _idController.dispose();
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
            LoginHeader(roleLabel: widget.roleLabel),
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
                        SignupField(
                          label: widget.idLabel,
                          hint: widget.idHint,
                          controller: _idController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        SignupField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _isPasswordHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
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
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ForgotPasswordPage(
                                    roleLabel: widget.roleLabel,
                                    idLabel: widget.idLabel,
                                    idHint: widget.idHint,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTypography.buttonLink.copyWith(
                                color: AppColors.agapOrangeDeep,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: LoginButton(
                            onPressed: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AuthSwitchPrompt(
                          promptText: "Don’t have an account? ",
                          actionText: 'Sign Up',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ResponderSignupPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.roleLabel} login is ready for backend hookup.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
