// import 'package:flutter/material.dart';

import 'package:agap/core/services/supabase_service.dart';

class ResidentService {

  final client = SupabaseService.client;

  Future<void> updateBasicInfo({
    required String firstName,
    String? middleName,
    required String lastName,
    String? suffix,
    required String phone,
    // required DateTime birthdate,
    // required String sex,
  }) async {
    final userId = client.auth.currentUser!.id;

    final data = {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      // 'birthdate': birthdate.toIso8601String().split('T')[0],
      // 'sex': sex.toLowerCase()
    };

    if (middleName != null) data['middle_name'] = middleName;
    if (suffix != null) data['suffix'] = suffix;

    await client.from('resident').update(data).eq('id', userId);
  }

  Future<void> updateAddress({
    String? houseNo,
    String? street,
    required String barangay,
    String? municipality,
    required String city,
    required String province,
    required String region,
    String? postalCode,
    String? landmark,
  }) async {
    final userId = client.auth.currentUser!.id;

    final data = {
      'barangay': barangay,
      'city': city,
      'province': province,
      'region': region,
    };

    if (houseNo != null) data['house_no'] = houseNo;
    if (street != null) data['street'] = street;
    if (municipality != null) data['municipality'] = municipality;
    if (postalCode != null) data['postal_code'] = postalCode;
    if (landmark != null) data['landmark'] = landmark;

    await client.from('resident').update(data).eq('id', userId);
  }

  Future<void> updateHousehold({
    required int householdSize,
    required int children,
    required int elderly,
    required int disabled,
    String? pets,
  }) async {
    final userId = client.auth.currentUser!.id;

    final data = {
      'household_size': householdSize,
      'children': children,
      'elderly': elderly,
      'disabled': disabled,
      ...? (pets != null ? {'pets': pets} : null),
    };

    await client.from('resident').update(data).eq('id', userId);
  }

  Future<void> updateMedicalProfile({
    String? conditions,
    String? history,
    String? allergies,
    String? medications,
  }) async {
    final userId = client.auth.currentUser!.id;

    final Map<String, dynamic> data = {
    ...?(conditions != null ? {'conditions': conditions} : null),
    ...?(history != null ? {'history': history} : null),
    ...?(allergies != null ? {'allergies': allergies} : null),
    ...?(medications != null ? {'medications': medications} : null),
    'last_medical_update': DateTime.now().toIso8601String(),
  };

  if (data.isEmpty) return;

    await client.from('resident').update(data).eq('id', userId);
  }

  Future<List<dynamic>> getNotifications() async {
    final userId = client.auth.currentUser!.id;

    final res = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return res;
  }



  // Future<void> updateProfile(Map<String, dynamic> data) async {
  //   final user = client.auth.currentUser;

  //   if (user == null) {
  //     debugPrint("updateProfile: No logged-in user found");
  //     throw Exception("User not logged in");
  //   }

  //   debugPrint("updateProfile: Preparing to update profile for user ${user.id}");
  //   debugPrint("updateProfile: Data to update -> $data");
    
  //   try {
  //     final response = await client
  //         .from('resident')
  //         .update(data)
  //         .eq('id', user.id);

  //     debugPrint("updateProfile: Update response -> $response");
  //     debugPrint("updateProfile: Profile update successful for user ${user.id}");
  //   } catch (e) {
  //     debugPrint("updateProfile: Error updating profile -> $e");
  //     throw Exception("Failed to update profile: $e");
  //   }
  // }
}