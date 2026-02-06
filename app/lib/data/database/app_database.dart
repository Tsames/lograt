import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_exercise_type_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_template_model.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
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

    // Todo: Add foreign key constraints to production database like in the test database
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
        await db.execute(_createExercisesTableSQL());
        await db.execute(_createExerciseTemplatesTableSQL());
        await db.execute(_createSetsTableSQL());
        await db.execute(_createSetTemplatesTableSQL());
        await db.execute(_createMuscleGroupsTableSQL());
        await db.execute(_createMuscleGroupsToWorkoutsTableSQL());
        await db.execute(_createMuscleGroupsToTemplatesTableSQL());
        await db.execute(_createMuscleGroupsToExerciseTypeTableSQL());
      },
      onOpen: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
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
      _createExercisesTableSQL(),
      _createExerciseTemplatesTableSQL(),
      _createSetsTableSQL(),
      _createSetTemplatesTableSQL(),
      _createMuscleGroupsTableSQL(),
      _createMuscleGroupsToWorkoutsTableSQL(),
      _createMuscleGroupsToTemplatesTableSQL(),
      _createMuscleGroupsToExerciseTypeTableSQL(),
    ];
  }

  // Build the incremental migration steps for existing databases
  List<String> _buildMigrationScripts() {
    return [];
  }

  String _createWorkoutsTableSQL() {
    return '''
      CREATE TABLE ${WorkoutModel.tableName}(
        ${WorkoutModel.idFieldName} TEXT PRIMARY KEY,
        ${WorkoutModel.dateFieldName} INTEGER NOT NULL,
        ${WorkoutModel.titleFieldName} TEXT,
        ${WorkoutModel.templateIdFieldName} TEXT,
        ${WorkoutModel.notesFieldName} TEXT,
        FOREIGN KEY (${WorkoutModel.templateIdFieldName}) REFERENCES $workoutTemplatesTable(${WorkoutTemplateFields.id}) ON DELETE SET NULL
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
      CREATE TABLE ${ExerciseTypeModel.tableName}(
        ${ExerciseTypeModel.idFieldName} TEXT PRIMARY KEY,
        ${ExerciseTypeModel.nameFieldName} TEXT NOT NULL UNIQUE,
        ${ExerciseTypeModel.descriptionFieldName} TEXT
      )
    ''';
  }

  String _createExercisesTableSQL() {
    return '''
    CREATE TABLE ${ExerciseModel.tableName}(
      ${ExerciseModel.idFieldName} TEXT PRIMARY KEY,
      ${ExerciseModel.orderFieldName} INTEGER NOT NULL,
      ${ExerciseModel.workoutIdFieldName} TEXT NOT NULL,
      ${ExerciseModel.exerciseTypeIdFieldName} TEXT,
      ${ExerciseModel.notesFieldName} TEXT,
      FOREIGN KEY (${ExerciseModel.workoutIdFieldName}) REFERENCES ${WorkoutModel.tableName}(${WorkoutModel.idFieldName}) ON DELETE CASCADE,
      FOREIGN KEY (${ExerciseModel.exerciseTypeIdFieldName}) REFERENCES ${ExerciseTypeModel.tableName}(${ExerciseTypeModel.idFieldName}) ON DELETE CASCADE
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
      FOREIGN KEY (${ExerciseTemplateFields.exerciseTypeId}) REFERENCES ${ExerciseTypeModel.tableName}(${ExerciseTypeModel.idFieldName}) ON DELETE CASCADE
    )
  ''';
  }

  String _createSetsTableSQL() {
    return '''
    CREATE TABLE ${ExerciseSetModel.tableName}(
      ${ExerciseSetModel.idFieldName} TEXT PRIMARY KEY,
      ${ExerciseSetModel.orderFieldName} INTEGER NOT NULL,
      ${ExerciseSetModel.exerciseIdFieldName} TEXT NOT NULL,
      ${ExerciseSetModel.setTypeFieldName} TEXT,
      ${ExerciseSetModel.weightFieldName} REAL,
      ${ExerciseSetModel.unitsFieldName} TEXT,
      ${ExerciseSetModel.repsFieldName} INTEGER,
      ${ExerciseSetModel.restTimeSecondsFieldName} INTEGER,
      FOREIGN KEY (${ExerciseSetModel.exerciseIdFieldName}) REFERENCES ${ExerciseModel.tableName}(${ExerciseModel.idFieldName}) ON DELETE CASCADE
    )
    ''';
  }

  String _createSetTemplatesTableSQL() {
    return '''
    CREATE TABLE $setTemplateTable(
      ${ExerciseSetTemplateFields.id} TEXT PRIMARY KEY,
      ${ExerciseSetTemplateFields.order} INTEGER NOT NULL,
      ${ExerciseSetTemplateFields.exerciseTemplateId} TEXT NOT NULL,
      ${ExerciseSetTemplateFields.units} TEXT,
      ${ExerciseSetTemplateFields.setType} TEXT,
      FOREIGN KEY (${ExerciseSetTemplateFields.exerciseTemplateId}) REFERENCES $exerciseTemplatesTable(${ExerciseTemplateFields.id}) ON DELETE CASCADE
    )
  ''';
  }

  String _createMuscleGroupsTableSQL() {
    return '''
      CREATE TABLE $muscleGroupsTable(
        ${MuscleGroupFields.id} TEXT PRIMARY KEY,
        ${MuscleGroupFields.label} TEXT NOT NULL UNIQUE,
        ${MuscleGroupFields.description} TEXT
      )
    ''';
  }

  String _createMuscleGroupsToWorkoutsTableSQL() {
    return '''
    CREATE TABLE $MuscleGroupToWorkoutModel(
      ${MuscleGroupToWorkoutModel.idFieldName} TEXT PRIMARY KEY,
      ${MuscleGroupToWorkoutModel.muscleGroupIdFieldName} TEXT NOT NULL,
      ${MuscleGroupToWorkoutModel.workoutIdFieldName} TEXT NOT NULL,
      FOREIGN KEY (${MuscleGroupToWorkoutModel.workoutIdFieldName}) REFERENCES ${WorkoutModel.tableName}(${WorkoutModel.idFieldName}) ON DELETE CASCADE,
      FOREIGN KEY (${MuscleGroupToWorkoutModel.muscleGroupIdFieldName}) REFERENCES $muscleGroupsTable(${MuscleGroupFields.id}) ON DELETE CASCADE,
      UNIQUE(${MuscleGroupToWorkoutModel.workoutIdFieldName}, ${MuscleGroupToWorkoutModel.muscleGroupIdFieldName})
    )
  ''';
  }

  String _createMuscleGroupsToTemplatesTableSQL() {
    return '''
    CREATE TABLE ${MuscleGroupToWorkoutTemplateModel.tableName}(
      ${MuscleGroupToWorkoutTemplateModel.idFieldName} TEXT PRIMARY KEY,
      ${MuscleGroupToWorkoutTemplateModel.muscleGroupIdFieldName} TEXT NOT NULL,
      ${MuscleGroupToWorkoutTemplateModel.workoutTemplateIdFieldName} TEXT NOT NULL,
      FOREIGN KEY (${MuscleGroupToWorkoutTemplateModel.workoutTemplateIdFieldName}) REFERENCES $workoutTemplatesTable(${WorkoutTemplateFields.id}) ON DELETE CASCADE,
      FOREIGN KEY (${MuscleGroupToWorkoutTemplateModel.muscleGroupIdFieldName}) REFERENCES $muscleGroupsTable(${MuscleGroupFields.id}) ON DELETE CASCADE,
      UNIQUE(${MuscleGroupToWorkoutTemplateModel.workoutTemplateIdFieldName}, ${MuscleGroupToWorkoutTemplateModel.muscleGroupIdFieldName})
    )
  ''';
  }

  String _createMuscleGroupsToExerciseTypeTableSQL() {
    return '''
    CREATE TABLE ${MuscleGroupToExerciseTypeModel.tableName}(
      ${MuscleGroupToExerciseTypeModel.idFieldName} TEXT PRIMARY KEY,
      ${MuscleGroupToExerciseTypeModel.muscleGroupIdFieldName} TEXT NOT NULL,
      ${MuscleGroupToExerciseTypeModel.exerciseTypeIdFieldName} TEXT NOT NULL,
      FOREIGN KEY (${MuscleGroupToExerciseTypeModel.muscleGroupIdFieldName}) REFERENCES $muscleGroupsTable(${MuscleGroupFields.id}) ON DELETE CASCADE,
      FOREIGN KEY (${MuscleGroupToExerciseTypeModel.exerciseTypeIdFieldName}) REFERENCES ${ExerciseTypeModel.tableName}(${ExerciseTypeModel.idFieldName}) ON DELETE CASCADE,
      UNIQUE(${MuscleGroupToExerciseTypeModel.muscleGroupIdFieldName}, ${MuscleGroupToExerciseTypeModel.exerciseTypeIdFieldName})
    )
  ''';
  }
}
