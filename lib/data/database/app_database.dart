import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  final String connectionString;

  AppDatabase(this.connectionString);

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initialize();
    return _database!;
  }

  Future<Database> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, connectionString);
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, createdOn INTEGER NOT NULL)',
    );
  }
}
