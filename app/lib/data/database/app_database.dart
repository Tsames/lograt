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
        await db.execute(_createWorkoutExercisesTableSQL());
        await db.execute(_createWorkoutSetsTableSQL());
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
      _createWorkoutExercisesTableSQL(),
      _createWorkoutSetsTableSQL(),
      _createWorkoutsTableCreatedOnIndexSQL(),
    ];
  }

  // Build the incremental migration steps for existing databases
  List<String> _buildMigrationScripts() {
    return [];
  }

  String _createWorkoutsTableSQL() {
    return '''
      CREATE TABLE $workoutsTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        createdOn INTEGER NOT NULL
      )
    ''';
  }

  String _createExerciseTypesTableSQL() {
    return '''
      CREATE TABLE $exerciseTypesTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''';
  }

  String _createWorkoutExercisesTableSQL() {
    return '''
      CREATE TABLE $exercisesTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        exercise_type_id INTEGER NOT NULL,
        exercise_order INTEGER NOT NULL,
        notes TEXT,
        FOREIGN KEY (workout_id) REFERENCES $workoutsTableName(id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_type_id) REFERENCES $exerciseTypesTableName(id) ON DELETE RESTRICT
      )
    ''';
  }

  String _createWorkoutSetsTableSQL() {
    return '''
    CREATE TABLE $exerciseSetsTableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise_id INTEGER NOT NULL,
      set_order INTEGER NOT NULL,
      reps INTEGER NOT NULL,
      weight REAL,
      units TEXT,
      rest_time_seconds INTEGER,
      set_type TEXT,
      notes TEXT,
      FOREIGN KEY (exercise_id) REFERENCES $exercisesTableName(id) ON DELETE CASCADE
    )
    ''';
  }

  String _createWorkoutsTableCreatedOnIndexSQL() {
    return '''
    CREATE INDEX idx_workouts_created_on ON $workoutsTableName(createdOn)
    ''';
  }
}
