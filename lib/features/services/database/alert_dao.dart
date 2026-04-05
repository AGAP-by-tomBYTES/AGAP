import 'package:sqflite/sqflite.dart';
import '../models/alert.dart';
import 'offline_db_service.dart';

class AlertDao {
  static Future<void> insertAlert(Alert alert) async {
    final db = await DatabaseService.database;
    await db.insert('alerts',
    alert.toJson()..putIfAbsent('uploaded', () => 0),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Alert>> getAlerts() async {
    final db = await DatabaseService.database;
    final result = await db.query('alerts');
    return result.map((json) => Alert.fromJson(json)).toList();
  }

  static Future<bool> alertExists(String id) async {
    final db = await DatabaseService.database;
    final result = await db.query('alerts', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  static Future<void> insertReceivedAlert({required String alertId, required String fromDevice, required String type, int ttl = 5}) async {
    final db = await DatabaseService.database;
    await db.insert('received_alerts', {
      'alertId': alertId,
      'receivedAt': DateTime.now().millisecondsSinceEpoch,
      'fromDevice': fromDevice,
      'ttl': ttl,
      'isForwarded': 0,
      'type': type,
    });
  }

  static Future<void> markAsForwarded(String alertId) async {
    final db = await DatabaseService.database;
    await db.update('received_alerts', {'isForwarded': 1}, 
    where: 'alertId = ?', 
    whereArgs: [alertId]);
  }

  static Future<void> markLocalUploaded(String alertId) async {
    final db = await DatabaseService.database;
    await db.update(
      'alerts',
      {'uploaded': 1},
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }

  static Future<void> markReceivedUploaded(String alertId) async {
    final db = await DatabaseService.database;
    await db.update(
      'received_alerts',
      {'uploaded': 1},
      where: 'alertId = ?',
      whereArgs: [alertId],
    );
  }

  static Future<List<Map<String, dynamic>>> getUnforwardedReceivedAlerts() async {
    final db = await DatabaseService.database;
    final result = await db.query(
      'received_alerts',
      where: 'isForwarded = ?',
      whereArgs: [0],
    );
    return result;
  }

    static Future<List<Map<String, dynamic>>> getPendingLocalUploads() async {
      final db = await DatabaseService.database;
      return await db.query(
        'alerts',
        where: 'uploaded = ?',
        whereArgs: [0],
      );
    }

    static Future<List<Map<String, dynamic>>> getPendingReceivedUploads() async {
      final db = await DatabaseService.database;
      return await db.query(
        'received_alerts',
        where: 'uploaded = ?',
        whereArgs: [0],
      );
    }
  


  /* ======= FOR UNIT TEST ONLY ======= */

  static Future<void> clearAllAlerts() async {
    final db = await DatabaseService.database;
    await db.delete('alerts');
    await db.delete('received_alerts');
  }
}