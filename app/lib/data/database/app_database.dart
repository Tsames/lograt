import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class AppDatabase {
  final String connectionString;
  Database? _database;

  AppDatabase._(this.connectionString);

  factory AppDatabase.create() {
    return AppDatabase._('lograt.db');
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
    // For in-memory databases (testing), use simple initialization without migration tracking
    if (connectionString == ':memory:') {
      return await _initializeTestDatabase(connectionString);
    }

    final path = join(await getDatabasesPath(), connectionString);

    final config = MigrationConfig(
      initializationScript: _buildInitializationScript(),
      migrationScripts: _buildMigrationScripts(),
    );

    return await openDatabaseWithMigration(path, config);
  }

  Future<Database> _initializeTestDatabase(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(_createWorkoutsTableSQL());
        await db.execute(_createExerciseTypesTableSQL());
        await db.execute(_createExercisesTableSQL());
        await db.execute(_createSetsTableSQL());
      },
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null; // Reset for next use
    }
  }

  static const workoutsTableName = 'workouts';
  static const exerciseTypesTableName = "exercise_types";
  static const exercisesTableName = "workout_exercises";
  static const exerciseSetsTableName = "exercise_sets";

  // Build the complete schema for new installations
  List<String> _buildInitializationScript() {
    return [
      _createWorkoutsTableSQL(),
      _createExerciseTypesTableSQL(),
      _createExercisesTableSQL(),
      _createSetsTableSQL(),
    ];
  }

  // Build the incremental migration steps for existing databases
  List<String> _buildMigrationScripts() {
    return [];
  }

  String _createWorkoutsTableSQL() {
    return '''
      CREATE TABLE $workoutsTableName(
        id TEXT PRIMARY KEY,
        date INTEGER NOT NULL,
        title TEXT,
        notes TEXT
      )
    ''';
  }

  String _createExerciseTypesTableSQL() {
    return '''
      CREATE TABLE $exerciseTypesTableName(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''';
  }

  String _createExercisesTableSQL() {
    return '''
    CREATE TABLE $exercisesTableName(
      id TEXT PRIMARY KEY,
      order INTEGER NOT NULL,
      workout_id TEXT NOT NULL,
      exercise_type_id TEXT,
      notes TEXT,
      FOREIGN KEY (workout_id) REFERENCES $workoutsTableName(id) ON DELETE CASCADE,
      FOREIGN KEY (exercise_type_id) REFERENCES $exerciseTypesTableName(id) ON DELETE RESTRICT
    )
  ''';
  }

  String _createSetsTableSQL() {
    return '''
    CREATE TABLE $exerciseSetsTableName(
      id TEXT PRIMARY KEY,
      order INTEGER NOT NULL,
      exercise_id TEXT NOT NULL,
      set_type TEXT,
      weight REAL,
      units TEXT,
      reps INTEGER,
      rest_time_seconds INTEGER,
      FOREIGN KEY (exercise_id) REFERENCES $exercisesTableName(id) ON DELETE CASCADE
    )
    ''';
  }
}
