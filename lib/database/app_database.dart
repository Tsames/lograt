import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  // Database constants
  static const _databaseName = "lograt_database.db";
  static const _version = 1;

  // Table names
  static const workoutsTable = 'workouts';

  static final AppDatabase _instance = AppDatabase._internal();
  AppDatabase._internal();
  factory AppDatabase() => _instance;

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $workoutsTable(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, createdOn INTEGER NOT NULL)',
    );
  }
}
