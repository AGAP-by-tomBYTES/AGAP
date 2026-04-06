import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/responder/data/responder_dashboard_data.dart';

Future<void> createIncidentReport(String alertId, String responderId) async {

  final client = SupabaseService.client;

  // Assume you already have the alertId from your app state
  final alert = await client
      .from('alerts')
      .select('resident_id, type')
      .eq('id', alertId)   // <-- use the real alertId here
      .single();

  final residentId = alert['resident_id'];
  final incidentType = alert['type'];

  // Now fetch the resident profile
  final resident = await client
      .from('resident')
      .select()
      .eq('id', residentId)
      .single();

  // Finally insert into incident_report
  await client.from('incident_report').insert({
    'sos_alert_id': alertId,
    'responder_id': responderId,
    'resident_id': residentId,
    'incident_category': 'Emergency', // default
    'incident_type': incidentType,    // from alerts.type
    'patient_last_name': resident['last_name'],
    'patient_first_name': resident['first_name'],
    'patient_middle_initial': resident['middle_initial'],
    'patient_address': resident['address'],
    'patient_age': resident['age'],
    'patient_sex': resident['sex'],
    'patient_contact': resident['contact'],
    'next_of_kin': resident['guardian_name'],
    'nok_contact': resident['guardian_contact'],
    'allergies': resident['allergies'],
    'medications': resident['medications'],
    'past_medical_history': resident['history'],
  });
}

Future<ResidentIncidentData> fetchIncidentReport(String alertId, String responderId) async {
  final client = SupabaseService.client;

  final report = await client
      .from('incident_report')
      .select()
      .eq('sos_alert_id', alertId)
      .eq('responder_id', responderId)
      .single();

  return ResidentIncidentData(
    name: '${report['patient_last_name']} ${report['patient_first_name']}',
    address: report['patient_address'] ?? '',
    age: report['patient_age'] ?? '',
    gender: report['patient_sex'] ?? '',
    details: [
      ResidentDetailData(label: 'Contact', value: report['patient_contact'] ?? ''),
      ResidentDetailData(label: 'Guardian', value: report['next_of_kin'] ?? ''),
      ResidentDetailData(label: 'NOK', value: report['nok_contact'] ?? ''),
      ResidentDetailData(label: 'Allergies', value: report['allergies'] ?? ''),
      ResidentDetailData(label: 'Medications', value: report['medications'] ?? ''),
      ResidentDetailData(label: 'History', value: report['past_medical_history'] ?? ''),
    ],
    detailsTitle: report['signs_symptoms'] ?? '',
    category: report['incident_type'] ?? 'Medical',
    reportedAt: report['date_of_call'] ?? '',
  );
}
