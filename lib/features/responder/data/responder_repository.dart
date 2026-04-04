import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/data/responder_dashboard_preview_data.dart';

class ResponderRepository {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required String phone,
    required String employeeIdNumber,
    required String responderRole,
    Uint8List? idImageBytes,
    String? idImageName,
  }) async {
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final userId = authResponse.user?.id;
    if (userId == null) throw Exception('Account creation failed.');

    try {
      String? idDocumentUrl;
      if (idImageBytes != null && idImageName != null) {
        final path = 'responders/$userId/$idImageName';
        await _client.storage
            .from('verification-documents')
            .uploadBinary(path, idImageBytes);
        idDocumentUrl = path;
      }

      await _client.from('responders').insert({
        'auth_user_id': userId,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'employee_id_number': employeeIdNumber,
        'responder_role': responderRole,
        'id_document_url': idDocumentUrl,
      });
    } catch (e) {
      await _client.auth.admin.deleteUser(userId);
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<Map<String, dynamic>?> getCurrentResponder() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    return await _client
        .from('responders')
        .select()
        .eq('auth_user_id', userId)
        .single();
  }

  Future<ResponderDashboardData> getDashboardData() async {
    final row = await getCurrentResponder();
    if (row == null) throw Exception('No responder profile found.');

    final firstName  = row['first_name']  as String? ?? '';
    final middleName = row['middle_name'] as String? ?? '';
    final lastName   = row['last_name']   as String? ?? '';

    final fullName = [
      firstName,
      if (middleName.trim().isNotEmpty) middleName,
      lastName,
    ].join(' ').trim();

    return ResponderDashboardData(
      profile: ResponderProfileData(
        name: fullName,
        teamAndStationLabel: 'Team Alpha – Miagao Station',
      ),
      alertSummary: const AlertSummaryData(
        activeCount: 0,
        totalCount: 0,
        resolvedCount: 0,
      ),
      teamStation: const TeamStationData(
        team: 'Team Alpha',
        station: 'Station 3 - Banwa, Miagao',
      ),
      weatherAdvisory: const WeatherAdvisoryData(
        title: 'Weather advisory',
        message: 'PAGASA advisory details will appear here once the live weather report is connected.',
      ),
      resolvedAlerts: const [],
      emergencyDispatch: responderDashboardPreviewData.emergencyDispatch,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut(); 
  }
}