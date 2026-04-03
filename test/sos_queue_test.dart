// test/sos_queue_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:uuid/uuid.dart';


void main() {
  // Initialize FFI for sqflite in tests
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Insert and process SOS queue', () async {
    final alert = Alert(
      id: const Uuid().v4(),
      type: "SAFE",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      senderId: "test_device",
    );

    await AlertDao.insertAlert(alert);

    final alerts = await AlertDao.getAlerts();
    print('Alerts in DB: ${alerts.map((a) => a.id).toList()}');

    // simulate queue
    final unforwarded = await AlertDao.getUnforwardedReceivedAlerts();
    print('Unforwarded alerts: $unforwarded');
  });
}