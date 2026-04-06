import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
// import 'dart:io';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/resident/models/resident_data.dart';

/*
helper class for authentication
 */
class AuthService {

  final client = SupabaseService.client;
  bool _isFetchingResident = false;

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

      final session = client.auth.currentSession;
      final box = Hive.box("app_cache");

      if (session != null) {
        final sessionString = jsonEncode(session.toJson());
        box.put("supabase_session", sessionString);
        debugPrint("Session cached");
      }


      box.put("user_id", response.user!.id);
      box.put("user_email", response.user!.email);

      final userId = response.user!.id;

      final resident = await client
        .from('resident')
        .select()
        .eq('id', userId)
        .maybeSingle();

      if (resident != null) {
        box.put("user_role", "resident");
        debugPrint("Role detected: resident");
      } else {
        final responder = await client
            .from('responders')
            .select()
            .eq('auth_user_id', userId)
            .maybeSingle();

        if (responder != null) {
          box.put("user_role", "responder");
          debugPrint("Role detected: responder");
        } else {
          throw Exception("User role not found");
        }
      }

      debugPrint("Login success");

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
      final box = Hive.box("app_cache");

      try {
        debugPrint("AuthService: Signing out from Supabase");
        await client.auth.signOut();
      } catch (e) {
        debugPrint("AuthService: Supabase signOut failed = $e");
      }

      debugPrint("AuthService: Clearing local cache");

      await box.delete("supabase_session");
      await box.delete("user_role");
      await box.delete("user_id");
      await box.delete("user_email");
      await box.delete("resident_data");

      debugPrint("AuthService: Local session cleared");
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
    final box = Hive.box("app_cache");
    final user = client.auth.currentUser;

    debugPrint("resident: fetch start");

    if (user == null) {
      debugPrint("resident: no logged in user");
      return null;
    }

    if (_isFetchingResident) {
      debugPrint("resident: already fetching, returning cache");

      final cached = box.get("resident_data");

      if (cached is String) {
        try {
          final decoded = jsonDecode(cached);
          if (decoded is Map<String, dynamic>) {
            debugPrint("resident: cache hit during active fetch");
            return decoded;
          }
        } catch (_) {}
      }

      return null;
    }

    _isFetchingResident = true;

    try {
      debugPrint("resident: fetching from supabase for ${user.id}");

      final data = await client
          .from('resident')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        debugPrint("resident: data received from supabase");

        final model = ResidentData.fromJson({
          ...data,
          "email": user.email,
        });

        final encoded = jsonEncode(model.toJson());

        debugPrint("resident: encoded length = ${encoded.length}");

        box.put("resident_data", encoded);

        debugPrint("resident: cache saved successfully");

        return model.toJson();
      }

    } catch (e) {
      debugPrint("resident: fetch error = $e");
      debugPrint("resident: fallback to cache triggered");
    } finally {
      _isFetchingResident = false;
    }

    final cached = box.get("resident_data");

    if (cached is String) {
      try {
        final decoded = jsonDecode(cached);

        if (decoded is Map<String, dynamic>) {
          debugPrint("resident: returning cached data (final)");
          return decoded;
        }
      } catch (e) {
        debugPrint("resident: cache decode error = $e");
        box.delete("resident_data");
      }
    }

    debugPrint("resident: no data available");
    return null;
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
}