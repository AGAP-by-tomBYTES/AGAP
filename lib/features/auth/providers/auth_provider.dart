import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agap/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());