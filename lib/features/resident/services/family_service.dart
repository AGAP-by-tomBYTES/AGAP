import 'package:agap/core/services/supabase_service.dart';

class FamilyService {
  final client = SupabaseService.client;

  //get all family members
  Future<List<Map<String, dynamic>>> getFamilyMembers() async {
    final userId = client.auth.currentUser!.id;

    final response = await client
        .from('family_view')
        .select()
        .eq('resident_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  //add non-registered member
  Future<void> addFamilyMember({
    required String firstName,
    required String lastName,
    String? relationship,
    String? phone,
    String? birthdate,
    String? conditions,
    String? history,
    String? allergies,
    String? medications,
    bool isNextOfKin = false,
  }) async {
    final userId = client.auth.currentUser!.id;

    await client.from('family_member').insert({
      'resident_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'relationship': relationship,
      'phone': phone,
      'birthdate': birthdate,
      'conditions': conditions,
      'history': history,
      'allergies': allergies,
      'medications': medications,
      'is_next_of_kin': isNextOfKin,
    });
  }

    Future<void> updateFamilyMember({
    required String id,
    required String firstName,
    required String lastName,
    required String relationship,
    String? phone,
    String? birthdate,
    String? conditions,
    String? history,
    String? allergies,
    String? medications,
    bool isNextOfKin = false,
  }) async {
    final data = {
      'first_name': firstName,
      'last_name': lastName,
      'relationship': relationship,
      'phone': phone,
      'birthdate': birthdate,
      'conditions': conditions,
      'history': history,
      'allergies': allergies,
      'medications': medications,
      'is_next_of_kin': isNextOfKin,
    };

    await client.from('family_member').update(data).eq('id', id);
  }


  //delete member
  Future<void> deleteFamilyMember(String id, bool isRegistered) async {
    if (isRegistered) {
      await client.from('resident_family').delete().eq('family_member_id', id);
    } else {
      await client.from('family_member').delete().eq('id', id);
    }
  }
}