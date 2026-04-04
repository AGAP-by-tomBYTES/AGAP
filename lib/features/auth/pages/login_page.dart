import 'package:flutter/material.dart';

import 'package:agap/config/app_config.dart';
import 'package:agap/features/auth/pages/forgot_password_page.dart';
import 'package:agap/features/auth/widgets/login_button.dart';
import 'package:agap/features/auth/widgets/login_header.dart';
import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';
import 'package:agap/features/responder/data/responder_repository.dart';
import 'package:agap/features/responder/pages/emergency_dashboard_page.dart';
import 'package:agap/features/responder/pages/normal_dashboard_page.dart';
import 'package:agap/features/responder/pages/signup.dart';
import 'package:agap/features/responder/widgets/auth_switch_prompt.dart';
import 'package:agap/features/responder/widgets/signup_field.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';
import 'package:agap/features/services/weather.dart';

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
  final _repository = ResponderRepository();
  bool _isPasswordHidden = true;
  bool _isSubmitting = false;

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
                          child: IgnorePointer(
                            ignoring: _isSubmitting,
                            child: Opacity(
                              opacity: _isSubmitting ? 0.72 : 1,
                              child: LoginButton(
                                onPressed: _handleLogin,
                              ),
                            ),
                          ),
                        ),
                        if (_isSubmitting) ...[
                          const SizedBox(height: 14),
                          const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: AppColors.agapOrangeDeep,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        AuthSwitchPrompt(
                          promptText: "Don’t have an account? ",
                          actionText: 'Sign Up',
                          onTap: () {
                            if (widget.roleLabel == 'Responder' &&
                                !AppConfig.isSupabaseConfigured) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Responder signup requires a .env file with Supabase keys.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.roleLabel != 'Responder') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resident dashboard routing is not set up yet.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final dashboardData = await _resolveResponderDashboardData();
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResponderEmergencyDashboardPage(data: dashboardData),
          // builder: (_) => ResponderNormalDashboardPage(data: dashboardData),
        ),
      );
    } catch (error) {
      debugPrint('LOGIN ERROR: $error'); 
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<ResponderDashboardData> _resolveResponderDashboardData() async {
    if (!AppConfig.isSupabaseConfigured) {
      return responderDashboardPreviewData;
    }

    final email    = _idController.text.trim();
    final password = _passwordController.text.trim();

    await _repository.signIn(email: email, password: password);

    final responder = await _repository.getCurrentResponder();
    if (responder == null) {
      throw Exception('Responder profile not found. Contact your administrator.');
    }

    return await _buildDashboardData(responder); // no longer needs await change — it's already awaited by the caller
  }

  //   await _repository.signIn(
  //     email: identifier,
  //     password: password,
  //   );

  //   final responder = await _repository.getCurrentResponder();
  //     if (responder == null) {
  //       throw Exception('Responder profile not found. Contact your administrator.');
  //     }
  //     return _buildDashboardData(responder);
  // }
  

  Future<ResponderDashboardData> _buildDashboardData(
      Map<String, dynamic> responder) async {
    final firstName  = responder['first_name']  as String? ?? '';
    final middleName = responder['middle_name'] as String? ?? '';
    final lastName   = responder['last_name']   as String? ?? '';

    final fullName = [
      firstName,
      if (middleName.trim().isNotEmpty) middleName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();

    Map<String, String> advisory;
    try {
      advisory = await WeatherService().getWeatherAdvisory();
      debugPrint(' WEATHER SUCCESS: $advisory');
    } catch (e) {
      debugPrint(' WEATHER ERROR: $e');
      advisory = {
        'title': 'Weather Advisory',
        'message': 'Unable to fetch live weather data.',
      };
    }

    return ResponderDashboardData(
      profile: ResponderProfileData(
        name: fullName.isEmpty ? 'Responder' : fullName,
        teamAndStationLabel: 'Team Alpha – Miagao Station',
      ),
      alertSummary: responderDashboardPreviewData.alertSummary,
      teamStation: responderDashboardPreviewData.teamStation,
      weatherAdvisory: WeatherAdvisoryData(
        title: advisory['title']!,
        message: advisory['message']!,
      ),
      resolvedAlerts: responderDashboardPreviewData.resolvedAlerts,
      emergencyDispatch: responderDashboardPreviewData.emergencyDispatch,
    );
  }
}