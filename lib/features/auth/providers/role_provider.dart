import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agap/features/auth/user_role.dart';

final selectedRoleProvider =
    StateProvider<UserRole?>((ref) => null);