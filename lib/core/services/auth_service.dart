import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/auth/models/user_profile.dart';

/*
helper class for authentication and user management
 */
class AuthService {

  final client = SupabaseService.client;
  final cache = Hive.box("app_cache");

  //get current user
  User? get currentUser => client.auth.currentUser;

  //sign up with profile data
  Future<String> signUpWithProfile({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required String gender,
    required String address,
    required bool isResponder,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password);

        final user = response.user;
        if (user == null) throw Exception("Sign up failed");

        final profile = UserProfile(
          id: user.id,
          email: email,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          gender: gender,
          address: address,
          isVerified: false,
          isResponder: isResponder,
        );

        await saveUserProfile(profile);

        if(isResponder) {
          await client.from('responders').insert({
            'user_id': user.id,
          });
        }

        return user.id;
    } on AuthException catch (e) {
      debugPrint("Auth error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("Sign up error: $e");
      throw Exception(e.toString());
    }
  }

  //sign in user
  Future<void> signIn({
    required String email,
    required String password,
    }) async {
      try {
        final response = await client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user == null) throw Exception("Login failed");
      } catch (e) {
        debugPrint("Sign in error: $e");
        throw Exception(e.toString());
      }
    }

  //get user profile, with caching for offline
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await client.from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
      
    if (data != null) {
      final profile = UserProfile.fromJson(data);
      cache.put('profile_$userId', profile.toJson());

      return profile;
    }

    return null;
    } catch (e) {
      debugPrint("Error fetching user profile: $e");

      final cachedData = cache.get('profile_$userId');
      if (cachedData != null) {
        return UserProfile.fromJson(Map<String, dynamic>.from(cachedData));
      }

      return null;
    }
  }

  //save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await client.from('users').upsert(profile.toJson());
      cache.put('profile_${profile.id}', profile.toJson());
    } catch (e) {
      debugPrint("Error saving user profile: $e");
      throw Exception(e.toString());
    }
  }

  //check if user is a responder
  Future<bool> isResponder(String userId) async {
    try {
      final data = await client.from('responders')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
      
      return data != null;
 
    } catch (e) {
      debugPrint("Error checking responder status: $e");
      return false;
    }
  }

  //sign out user
  Future<void> signOut() async {

    try {
      final userId = client.auth.currentUser?.id;
      await client.auth.signOut();
      
      if (userId != null) {
        cache.delete('profile_$userId');
      }
    } catch (e) {  
      debugPrint("Sign out error: $e");
      throw Exception(e.toString());
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
      throw Exception(e.toString());
    }
  }
}