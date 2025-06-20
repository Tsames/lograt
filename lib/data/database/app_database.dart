import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    final path = connectionString == ':memory:' ? ':memory:' : join(await getDatabasesPath(), connectionString);

    final config = MigrationConfig(
      initializationScript: _buildInitializationScript(),
      migrationScripts: _buildMigrationScripts(),
    );

    return await openDatabaseWithMigration(path, config);
  }

  // Build the complete schema for new installations
  List<String> _buildInitializationScript() {
    return [
      _createWorkoutsTableSQL(),
      _createExerciseTypesTableSQL(),
      _createWorkoutExercisesTableSQL(),
      _createIndexesSQL(),
    ];
  }

  // Build the incremental migration steps for existing databases
  List<String> _buildMigrationScripts() {
    return [
      _createExerciseTypesTableSQL(),
      _createWorkoutExercisesTableSQL(),
      _createIndexesSQL(),
      _createWorkoutSetsTableSQL(),
    ];
  }

  String _createWorkoutsTableSQL() {
    return '''
      CREATE TABLE workouts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        createdOn INTEGER NOT NULL
      )
    ''';
  }

  // Create the exercise_types reference table
  // This stores the definitions of different exercise types (e.g., "Push-ups", "Squats")
  String _createExerciseTypesTableSQL() {
    return '''
      CREATE TABLE exercise_types(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''';
  }

  // Create the workout_exercises junction table
  // This links workouts to exercise types and stores workout-specific data
  String _createWorkoutExercisesTableSQL() {
    return '''
      CREATE TABLE workout_exercises(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        exercise_type_id INTEGER NOT NULL,
        order_index INTEGER NOT NULL,
        notes TEXT,
        FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_type_id) REFERENCES exercise_types(id) ON DELETE RESTRICT
      )
    ''';
  }

  String _createWorkoutSetsTableSQL() {
    return '''
    CREATE TABLE workout_sets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise_id INTEGER NOT NULL,
      order INTEGER NOT NULL,
      reps INTEGER NOT NULL,
      weight INTEGER,
      rest_time_seconds INTEGER,
      setType TEXT,
      FOREIGN KEY (exercise_id) REFERENCES workout_exercises(id) ON DELETE CASCADE
    )
    ''';
  }

  // Create indexes for better query performance
  // These speed up common queries by creating sorted references to frequently searched columns
  String _createIndexesSQL() {
    return '''
      CREATE INDEX idx_workout_exercises_workout_id ON workout_exercises(workout_id);
      CREATE INDEX idx_workout_exercises_exercise_type_id ON workout_exercises(exercise_type_id);
      CREATE INDEX idx_workout_exercises_order ON workout_exercises(workout_id, order_index);
    ''';
  }
}
