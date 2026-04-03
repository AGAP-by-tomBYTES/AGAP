import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agap/features/auth/models/user_profile.dart';
import 'package:agap/features/auth/providers/auth_provider.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final bool isVerified;
  final bool isResponder;
  final UserProfile? profile;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    required this.isVerified,
    required this.isResponder,
    this.profile,
  });

  factory AuthState.initial() => AuthState(
        isLoading: true,
        isLoggedIn: false,
        isVerified: false,
        isResponder: false,
      );

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    bool? isVerified,
    bool? isResponder,
    UserProfile? profile,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isVerified: isVerified ?? this.isVerified,
      isResponder: isResponder ?? this.isResponder,
      profile: profile ?? this.profile,
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState.initial()) {
    init();
  }

  Future<void> init() async {
    final service = ref.read(authServiceProvider);
    final user = service.currentUser;

    if (user == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final profile = await service.getUserProfile(user.id);
    final isResponder = await service.isResponder(user.id);
    final isVerified = service.isVerified();

    state = state.copyWith(
      isLoading: false,
      isLoggedIn: true,
      isVerified: isVerified,
      isResponder: isResponder,
      profile: profile,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await init();
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = AuthState.initial().copyWith(isLoading: false);
  }
}