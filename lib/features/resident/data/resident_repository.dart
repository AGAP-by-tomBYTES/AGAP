import 'package:supabase_flutter/supabase_flutter.dart';
import 'resident_signup_data.dart';

class ResidentRepository {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> signUp(ResidentSignupData data) async {
    final authResponse = await _client.auth.signUp(
      email: data.email,
      password: data.password,
    );

    final residentId = authResponse.user?.id;
    if (residentId == null) throw Exception('Account creation failed.');

    await _client.from('residents').insert({
      'auth_resident_id': residentId,
      'first_name': data.firstName,
      'middle_name': data.middleName,
      'last_name': data.lastName,
      'suffix': data.suffix,
      'phone': data.phone,
      'email': data.email,

      // Location
      'house_no': data.houseNo,
      'street': data.street,
      'barangay': data.barangay,
      'city': data.city,
      'province': data.province,
      'postal_code': data.postalCode,

      // Household
      'household_size': data.householdSize,
      'children': data.children,
      'elderly': data.elderly,
      'disabled': data.disabled,
      'pets': data.pets,

      // Medical
      'conditions': data.conditions,
      'history': data.history,
      'allergies': data.allergies,
      'medications': data.medications,
    });
  }

  Future<Map<String, dynamic>?> getCurrentResident() async {
    final residentId = _client.auth.currentUser?.id;
    if (residentId == null) return null;

    return await _client
        .from('residents')
        .select()
        .eq('auth_resident_id', residentId)
        .single();
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}