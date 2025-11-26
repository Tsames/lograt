import 'package:lograt/data/models/exercise_model.dart';
import 'package:lograt/data/models/workout_model.dart';
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

  static const exerciseTypesTableName = 'exercise_types';
  static const exerciseSetsTableName = 'exercise_sets';

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
      CREATE TABLE $workoutTable(
        ${WorkoutFields.id} TEXT PRIMARY KEY,
        ${WorkoutFields.date} INTEGER NOT NULL,
        ${WorkoutFields.title} TEXT,
        ${WorkoutFields.notes} TEXT
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
    CREATE TABLE $exerciseTable(
      ${ExerciseFields.id} TEXT PRIMARY KEY,
      ${ExerciseFields.order} INTEGER NOT NULL,
      ${ExerciseFields.workoutId} TEXT NOT NULL,
      ${ExerciseFields.exerciseTypeId} TEXT,
      ${ExerciseFields.notes} TEXT,
      FOREIGN KEY (${ExerciseFields.workoutId}) REFERENCES $workoutTable(${WorkoutFields.id}) ON DELETE CASCADE,
      FOREIGN KEY (${ExerciseFields.exerciseTypeId}) REFERENCES $exerciseTypesTableName(id) ON DELETE RESTRICT
    )
  ''';
  }

  String _createSetsTableSQL() {
    return '''
    CREATE TABLE $exerciseSetsTableName(
      id TEXT PRIMARY KEY,
      set_order INTEGER NOT NULL,
      exercise_id TEXT NOT NULL,
      set_type TEXT,
      weight REAL,
      units TEXT,
      reps INTEGER,
      rest_time_seconds INTEGER,
      FOREIGN KEY (exercise_id) REFERENCES $exerciseTable(${ExerciseFields.id}) ON DELETE CASCADE
    )
    ''';
  }
}
