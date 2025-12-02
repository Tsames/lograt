import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
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
        await db.execute(_createWorkoutTemplatesTableSQL());
        await db.execute(_createExerciseTypesTableSQL());
        await db.execute(_createExerciseTemplatesTableSQL());
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

  // Build the complete schema for new installations
  List<String> _buildInitializationScript() {
    return [
      _createWorkoutsTableSQL(),
      _createWorkoutTemplatesTableSQL(),
      _createExerciseTypesTableSQL(),
      _createExerciseTemplatesTableSQL(),
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
      CREATE TABLE $workoutsTable(
        ${WorkoutFields.id} TEXT PRIMARY KEY,
        ${WorkoutFields.date} INTEGER NOT NULL,
        ${WorkoutFields.title} TEXT,
        ${WorkoutFields.templateId} TEXT,
        ${WorkoutFields.notes} TEXT,
        FOREIGN KEY (${WorkoutFields.templateId}) REFERENCES $workoutTemplatesTable(${WorkoutTemplateFields.id}) ON DELETE SET NULL
      )
    ''';
  }

  String _createWorkoutTemplatesTableSQL() {
    return '''
      CREATE TABLE $workoutTemplatesTable(
        ${WorkoutTemplateFields.id} TEXT PRIMARY KEY,
        ${WorkoutTemplateFields.date} INTEGER NOT NULL,
        ${WorkoutTemplateFields.title} TEXT,
        ${WorkoutTemplateFields.description} TEXT
      )
    ''';
  }

  String _createExerciseTypesTableSQL() {
    return '''
      CREATE TABLE $exerciseTypesTable(
        ${ExerciseTypeFields.id} TEXT PRIMARY KEY,
        ${ExerciseTypeFields.name} TEXT NOT NULL UNIQUE,
        ${ExerciseTypeFields.description} TEXT
      )
    ''';
  }

  String _createExercisesTableSQL() {
    return '''
    CREATE TABLE $exercisesTable(
      ${ExerciseFields.id} TEXT PRIMARY KEY,
      ${ExerciseFields.order} INTEGER NOT NULL,
      ${ExerciseFields.workoutId} TEXT NOT NULL,
      ${ExerciseFields.exerciseTypeId} TEXT,
      ${ExerciseFields.notes} TEXT,
      FOREIGN KEY (${ExerciseFields.workoutId}) REFERENCES $workoutsTable(${WorkoutFields.id}) ON DELETE CASCADE,
      FOREIGN KEY (${ExerciseFields.exerciseTypeId}) REFERENCES $exerciseTypesTable(${ExerciseTypeFields.id}) ON DELETE RESTRICT
    )
  ''';
  }

  String _createExerciseTemplatesTableSQL() {
    return '''
    CREATE TABLE $exerciseTemplatesTable(
      ${ExerciseTemplateFields.id} TEXT PRIMARY KEY,
      ${ExerciseTemplateFields.order} INTEGER NOT NULL,
      ${ExerciseTemplateFields.workoutTemplateId} TEXT NOT NULL,
      ${ExerciseTemplateFields.exerciseTypeId} TEXT,
      FOREIGN KEY (${ExerciseTemplateFields.workoutTemplateId}) REFERENCES $workoutTemplatesTable(${WorkoutTemplateFields.id}) ON DELETE CASCADE,
      FOREIGN KEY (${ExerciseTemplateFields.exerciseTypeId}) REFERENCES $exerciseTypesTable(${ExerciseTypeFields.id}) ON DELETE RESTRICT
    )
  ''';
  }

  String _createSetsTableSQL() {
    return '''
    CREATE TABLE $setsTable(
      ${ExerciseSetFields.id} TEXT PRIMARY KEY,
      ${ExerciseSetFields.order} INTEGER NOT NULL,
      ${ExerciseSetFields.exerciseId} TEXT NOT NULL,
      ${ExerciseSetFields.setType} TEXT,
      ${ExerciseSetFields.weight} REAL,
      ${ExerciseSetFields.units} TEXT,
      ${ExerciseSetFields.reps} INTEGER,
      ${ExerciseSetFields.restTimeSeconds} INTEGER,
      FOREIGN KEY (${ExerciseSetFields.exerciseId}) REFERENCES $exercisesTable(${ExerciseFields.id}) ON DELETE CASCADE
    )
    ''';
  }
}
