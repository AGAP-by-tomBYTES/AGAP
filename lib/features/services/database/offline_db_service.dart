import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agap.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // create tables for alerts, received alerts, and devices
  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS alerts (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        senderId TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS received_alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alertId TEXT NOT NULL,
        receivedAt INTEGER NOT NULL,
        fromDevice TEXT,
        ttl INTEGER NOT NULL,
        isForwarded INTEGER DEFAULT 0,
        type TEXT NOT NULL
      )
    ''');
  }
}