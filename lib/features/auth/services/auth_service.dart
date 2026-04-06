import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/resident/models/resident_data.dart';

/*
helper class for authentication
 */
class AuthService {

  final client = SupabaseService.client;

  //get current user
  User? get currentUser {
    final user = client.auth.currentUser;
    debugPrint("AuthService: currentUser = ${user?.id}");
    debugPrint("Email: ${user?.email}");
    debugPrint("Confirmed At: ${user?.emailConfirmedAt}");
    return user;
  } 

  //check if logged in  
  bool get isLoggedIn {
    final loggedIn = currentUser != null;
    debugPrint("AuthService: isLoggedIn = $loggedIn");
    return loggedIn;
  }

  //sign in user
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("AuthService: Attempting login for $email");
      
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        debugPrint("AuthService: Login failed (no user)");
        throw Exception("Login failed");
      }

      await client.auth.refreshSession();

      debugPrint("AuthService: Login success → ${response.user!.id}");

      return response.user!;
    }  on AuthException catch (e) {
        debugPrint("AuthService Auth error: ${e.message}");
        throw Exception(e.message);
    } catch (e) {
      debugPrint("AuthService Sign in error: $e");
      throw Exception("Something went wrong. Please try again.");
    }
  }

  //sign out user
  Future<void> signOut() async {
    try {
      debugPrint("AuthService: Signing out");
      await client.auth.signOut();
    } catch (e) {  
      debugPrint("Sign out error: $e");
      throw Exception("Failed to sign out.");
    }
  }

  //verification
  bool isVerified() {
    final verified = client.auth.currentUser?.emailConfirmedAt != null;
    debugPrint("AuthService: isVerified = $verified");
    return verified;
  }

  Future<void> refreshSession() async {
    await client.auth.refreshSession();
  }

  //to move
  Future<Map<String, dynamic>?> getCurrentResident() async {
    final residentId = client.auth.currentUser;

    if (residentId == null) {
      debugPrint("No logged in user");
    }

    try {
      final data = await client
        .from('resident')
        .select()
        .eq('id', residentId!.id)
        .maybeSingle();
      
      if (data == null) return null;
      
      final merged = {
        ...data,
      "email": residentId.email,
      };

      debugPrint("Resident data: $data");

      return merged;
    } catch (e) {
      debugPrint("Error getting resident profile: $e");
      return null;
    }
  }

  // sign up
  // Future<User> signUp({
  //   required String email,
  //   required String password
  // }) async {
  //   try {
  //     final response = await client.auth.signUp(
  //       email: email,
  //       password: password,
  //       emailRedirectTo: "io.supabase.agap://login-callback",
  //     );
      
  //     if (response.user == null) throw Exception("Sign up failed");

  //     return response.user!;
  //   } on AuthException catch (e) {
  //     debugPrint("Auth error: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     debugPrint("Sign up error: $e");
  //     throw Exception("Something went wrong. Please try again.");
  //   }
  // }

  //to move
  Future<bool> signUpResident(ResidentData data) async {
  final authResponse = await client.auth.signUp(
    email: data.email,
    password: data.password,
  );

  final residentId = authResponse.user?.id;
  if (residentId == null) throw Exception('Account creation failed.');

  debugPrint("Auth user created with id $residentId");

  // await client.from('resident').upsert({
  // 'id': residentId,
  // ...data.toJson(),
  // });

  await client.from('resident').upsert({
    'id': residentId,

    'first_name': data.firstName,
    'middle_name': data.middleName,
    'last_name': data.lastName,
    'suffix': data.suffix,
    'phone': data.phone,
    'birthdate': data.birthdate.toIso8601String().split('T')[0],
    'sex': data.sex,

    'house_no': data.houseNo,
    'street': data.street,
    'barangay': data.barangay,
    'municipality': data.municipality,
    'city': data.city,
    'province': data.province,
    'region': data.region,
    'postal_code': data.postalCode,
    'landmark': data.landmark,

    'household_size': data.householdSize,
    'children': data.children,
    'elderly': data.elderly,
    'disabled': data.disabled,
    'pets': data.pets,

    'conditions': data.conditions,
    'history': data.history,
    'allergies': data.allergies,
    'medications': data.medications,

    'profile_completed': true,
    'signup_step': 5,
  });

  final inserted = await client.from('resident')
    .select().eq('id', residentId).maybeSingle();
  
  if (inserted == null) {
    await client.auth.signOut();
    throw Exception("Failed to create resident profile");
  }

  debugPrint("Resident profile inserted successfully");
  return true;
}

  //resend supabase verification email
  // Future<void> resendVerificationEmail(String email) async {
 
  //   try {
  //     await client.auth.resend(
  //       type: OtpType.signup,
  //       email: email
  //     );
  //   } catch (e) {
  //     debugPrint("Error resending verification email: $e");
  //     throw Exception("Failed to resend verification email.");
  //   }
  // }

  // Future<bool> isVerifiedAsync() async {
  //   await client.auth.refreshSession();
  //   return client.auth.currentUser?.emailConfirmedAt != null;
  // }

  // Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}