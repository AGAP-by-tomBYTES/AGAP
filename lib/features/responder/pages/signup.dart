import 'package:flutter/material.dart';
import 'package:agap/features/responder/pages/signup_verification.dart';
import 'package:agap/features/responder/widgets/auth_switch_prompt.dart';
import 'package:agap/features/responder/widgets/signup_field.dart';
import 'package:agap/features/responder/widgets/signup_step_header.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

class ResponderSignupPage extends StatefulWidget {
  const ResponderSignupPage({super.key});

  @override
  State<ResponderSignupPage> createState() => _ResponderSignupPageState();
}

class _ResponderSignupPageState extends State<ResponderSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+63');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  @override
  void dispose() {
    _scrollController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SignupStepHeader(
              stepLabel: 'STEP 1 OF 2',
              sectionLabel: 'ACCOUNT',
              title: 'Create your account',
              description:
                  'Your details help us verify you as an authorized responder.',
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(999),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'First name',
                                hint: 'e.g. John',
                                controller: _firstNameController,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Last name',
                                hint: 'e.g. Dela Cruz',
                                controller: _lastNameController,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
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
                                hint: 'e.g. Villanueva',
                                controller: _middleNameController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Suffix',
                                hint: 'e.g. Jr.',
                                controller: _suffixController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Email',
                          hint: 'e.g. juan@mdrrmo.gov.ph',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!v.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().length < 12) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _isHiddenPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isHiddenPassword = !_isHiddenPassword;
                              });
                            },
                            icon: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscureText: _isHiddenConfirmPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isHiddenConfirmPassword =
                                    !_isHiddenConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _isHiddenConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _handleContinue,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.agapOrangeDeep,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(54),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'CONTINUE',
                                    style: AppTypography.buttonPrimary,
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.overlayWhiteStrong,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AuthSwitchPrompt(
                          promptText: 'Already have an account? ',
                          actionText: 'Log In',
                          onTap: () {
                            Navigator.of(context).pop();
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

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResponderSignupVerificationPage(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            firstName: _firstNameController.text.trim(),
            middleName: _middleNameController.text.trim().isEmpty
                ? null
                : _middleNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
          ),
        ),
      );
    }
  }
}