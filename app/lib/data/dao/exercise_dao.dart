import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:sqflite/sqflite.dart';

/// Data Access Object operations for an Exercise
/// This class handles all database operations related to exercises
class ExerciseDao {
  final AppDatabase _db;

  ExerciseDao(this._db);

  /// Get an exercise by its ID
  /// Returns null if no exercise with the given ID exists
  Future<ExerciseModel?> getById(String id) async {
    final database = await _db.database;
    final maps = await database.query(
      exercisesTable,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseModel.fromMap(maps.first);
  }

  /// Get all exercises for a specific workout, ordered by their sequence
  /// Does not include ExerciseType data
  Future<List<ExerciseModel>> getByWorkoutId(String workoutId) async {
    final database = await _db.database;
    final maps = await database.query(
      exercisesTable,
      where: '${ExerciseFields.workoutId} = ?',
      whereArgs: [workoutId],
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).nonNulls.toList();
  }

  // /// Get exercises with their exercise type information joined
  // /// This returns nearly complete Exercise domain entities
  // /// The returned Exercise domain entities have no set data.
  // /// Separate calls using the [ExerciseSetDao] should be made to complete the Exercise entity's data
  // Future<List<Exercise>> getExercisesWithTypesByWorkoutId(String workoutId) async {
  //   // Use a JOIN query to get exercise and exercise type data in one query
  //   // This is more efficient than making separate queries for each exercise
  //   final database = await _db.database;
  //   final maps = await database.rawQuery(
  //     '''
  //     SELECT
  //       we.id,
  //       we.workout_id,
  //       we.exercise_type_id,
  //       we.exercise_order,
  //       we.notes,
  //       et.name as exercise_type_name,
  //       et.description as exercise_type_description
  //     FROM $exercisesTable we
  //     JOIN exercise_types et ON we.exercise_type_id = et.id
  //     WHERE we.workout_id = ?
  //     ORDER BY we.exercise_order ASC
  //   ''',
  //     [workoutId],
  //   );
  //
  //   return maps.map((map) {
  //     // Reconstruct the ExerciseType from the joined data
  //     final exerciseType = ExerciseType(
  //       id: map['exercise_type_id'] as int,
  //       name: map['exercise_type_name'] as String,
  //       description: map['exercise_type_description'] as String?,
  //     );
  //
  //     // Create the Exercise domain entity with the complete exercise type
  //     return Exercise(
  //       id: map['id'] as int,
  //       exerciseType: exerciseType,
  //       order: map['order_index'] as int,
  //       sets: [],
  //       // ExerciseSet data needs to be gathered using a separate DAO
  //       notes: map['notes'] as String?,
  //     );
  //   }).toList();
  // }

  /// Get all exercises that use a specific exercise type
  Future<List<ExerciseModel>> getByExerciseTypeId({
    required String exerciseTypeId,
    required int limit,
  }) async {
    final database = await _db.database;
    final maps = await database.query(
      exercisesTable,
      where: '${ExerciseFields.exerciseTypeId} = ?',
      whereArgs: [exerciseTypeId],
      orderBy: '${ExerciseFields.workoutId} DESC',
      limit: limit,
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).nonNulls.toList();
  }

  /// Get the count of exercises in a specific workout
  Future<int> getCountByWorkoutId(String workoutId) async {
    final database = await _db.database;
    final result = await database.rawQuery(
      '''
      SELECT COUNT(*) as count 
      FROM $exercisesTable 
      WHERE ${ExerciseFields.workoutId} = ?
    ''',
      [workoutId],
    );

    return result.first['count'] as int;
  }

  /// Insert a new exercise
  /// Returns the ID of the newly inserted exercise
  Future<int> insert(ExerciseModel exercise) async {
    final database = await _db.database;
    return await database.insert(
      exercisesTable,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertWithTransaction({
    required ExerciseModel exercise,
    required Transaction txn,
  }) async {
    return await txn.insert(exercisesTable, exercise.toMap());
  }

  /// Update an existing exercise
  /// Returns the number of rows affected (should be 1 for success)
  Future<int> update(ExerciseModel exercise) async {
    final database = await _db.database;
    return await database.update(
      exercisesTable,
      exercise.toMap(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exercise.id],
    );
  }

  /// Delete an exercise from a workout
  Future<int> delete(String exerciseId) async {
    final exerciseToDelete = await getById(exerciseId);
    if (exerciseToDelete == null) return 0;

    final database = await _db.database;
    return await database.delete(
      exercisesTable,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exerciseId],
    );
  }

  /// Delete all exercises for a specific workout
  /// This is typically called when a workout is deleted
  Future<int> deleteByWorkoutId(String workoutId) async {
    final database = await _db.database;
    return await database.delete(
      exercisesTable,
      where: '${ExerciseFields.workoutId} = ?',
      whereArgs: [workoutId],
    );
  }

  Future<void> clearTable() async {
    final db = await _db.database;
    await db.delete(exercisesTable);
  }
}
