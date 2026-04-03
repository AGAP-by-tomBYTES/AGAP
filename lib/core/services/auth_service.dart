import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:agap/core/services/supabase_service.dart';

/*
helper class for authentication
 */
class AuthService {

  final client = SupabaseService.client;

  bool get isLoggedIn => currentUser != null;

  //get current user
  User? get currentUser => client.auth.currentUser;

  //sign up
  Future<User> signUp({
    required String email,
    required String password
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password
      );
      
      if (response.user == null) throw Exception("Sign up failed");

      return response.user!;
    } on AuthException catch (e) {
      debugPrint("Auth error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("Sign up error: $e");
      throw Exception("Something went wrong. Please try again.");
    }
  }

  //sign in user
  Future<User> signIn({
    required String email,
    required String password,
    }) async {
      try {
        final response = await client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user == null) throw Exception("Login failed");

        await client.auth.refreshSession();

        return response.user!;
      }  on AuthException catch (e) {
        debugPrint("Auth error: ${e.message}");
        throw Exception(e.message);
      } catch (e) {
        debugPrint("Sign in error: $e");
        throw Exception("Something went wrong. Please try again.");
      }
    }

  //sign out user
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {  
      debugPrint("Sign out error: $e");
      throw Exception("Failed to sign out.");
    }
  }

  //verification
  bool isVerified() {
    return client.auth.currentUser?.emailConfirmedAt != null;
  }

  //resend supabase verification email
  Future<void> resendVerificationEmail(String email) async {
 
    try {
      await client.auth.resend(
        type: OtpType.signup,
        email: email
      );
    } catch (e) {
      debugPrint("Error resending verification email: $e");
      throw Exception("Failed to resend verification email.");
    }
  }

  Future<bool> isVerifiedAsync() async {
    await client.auth.refreshSession();
    return client.auth.currentUser?.emailConfirmedAt != null;
  }

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}