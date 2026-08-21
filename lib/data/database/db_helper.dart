import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/print_history.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ch_print.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // onCreate est appelé la première fois pour créer la table
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE print_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at TEXT NOT NULL,
      vehicles TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertHistory(PrintHistory history) async {
    final db = await instance.database;
    return await db.insert('print_history', history.toMap());
  }

  Future<List<PrintHistory>> getAllHistory() async {
    final db = await instance.database;
    // On récupère du plus récent au plus ancien
    final result = await db.query('print_history', orderBy: 'created_at DESC');
    return result.map((json) => PrintHistory.fromMap(json)).toList();
  }

  Future<int> deleteHistory(int id) async {
    final db = await instance.database;
    return await db.delete('print_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearAll() async {
    final db = await instance.database;
    return await db.delete('print_history');
  }
}
