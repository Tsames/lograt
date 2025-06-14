import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  final String connectionString;
  Database? _database;

  AppDatabase._(this.connectionString);

  factory AppDatabase.create(String connectionString) {
    return AppDatabase._(connectionString);
  }

  factory AppDatabase.inMemory() {
    return AppDatabase._(':memory:');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initialize();
    return _database!;
  }

  Future<Database> initialize() async {
    if (connectionString == ':memory:') {
      // For in-memory databases, we don't need file paths at all
      return await openDatabase(':memory:', version: 1, onCreate: _createTables);
    } else {
      // For real databases, we use the file path logic
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, connectionString);
      return await openDatabase(path, version: 1, onCreate: _createTables);
    }
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, createdOn INTEGER NOT NULL)',
    );
  }
}
