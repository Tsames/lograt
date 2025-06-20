import 'package:lograt/data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/exercise.dart';
import '../../../domain/entities/exercise_type.dart';
import '../../models/exercise_model.dart';

/// Data Access Object operations for an Exercise that belongs to a Workout
class ExerciseDao {
  final AppDatabase _db;
  static const String tableName = 'workout_exercises';

  ExerciseDao(this._db);

  /// Insert a new exercise into a workout
  /// Returns the ID of the newly inserted exercise
  Future<int> insert(ExerciseModel exercise) async {
    final database = await _db.database;
    return await database.insert(tableName, exercise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Update an existing exercise in a workout
  /// Returns the number of rows affected (should be 1 for success)
  Future<int> update(ExerciseModel exercise) async {
    if (exercise.id == null) {
      throw ArgumentError('Cannot update exercise without an ID');
    }

    final database = await _db.database;
    return await database.update(tableName, exercise.toMap(), where: 'id = ?', whereArgs: [exercise.id]);
  }

  /// Delete an exercise from a workout
  /// This also handles reordering other exercises in the same workout
  Future<int> delete(int exerciseId) async {
    // First, get the exercise details to know which workout it belongs to
    final exerciseToDelete = await getById(exerciseId);
    if (exerciseToDelete == null) return 0;

    // Delete the exercise
    final database = await _db.database;
    final deletedCount = await database.delete(tableName, where: 'id = ?', whereArgs: [exerciseId]);

    return deletedCount;
  }

  /// Get an exercise by its ID
  /// Returns null if no exercise with the given ID exists
  Future<ExerciseModel?> getById(int id) async {
    final database = await _db.database;
    final maps = await database.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return ExerciseModel.fromMap(maps.first);
  }

  /// Get all exercises for a specific workout, ordered by their sequence
  /// This is the most common query - getting all exercises in a workout
  Future<List<ExerciseModel>> getByWorkoutId(int workoutId) async {
    final database = await _db.database;
    final maps = await database.query(
      tableName,
      where: 'workout_id = ?',
      whereArgs: [workoutId],
      orderBy: 'order_index ASC',
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).toList();
  }

  /// Get exercises with their exercise type information joined
  /// This returns complete Exercise domain entities ready for use in the UI
  Future<List<Exercise>> getExercisesWithTypesByWorkoutId(int workoutId) async {
    // Use a JOIN query to get exercise and exercise type data in one query
    // This is more efficient than making separate queries for each exercise
    final database = await _db.database;
    final maps = await database.rawQuery(
      '''
      SELECT 
        we.id,
        we.workout_id,
        we.exercise_type_id,
        we.order_index as order_index,
        we.notes,
        et.name as exercise_type_name,
        et.description as exercise_type_description
      FROM $tableName we
      JOIN exercise_types et ON we.exercise_type_id = et.id
      WHERE we.workout_id = ?
      ORDER BY we.order_index ASC
    ''',
      [workoutId],
    );

    return maps.map((map) {
      // Reconstruct the ExerciseType from the joined data
      final exerciseType = ExerciseType(
        id: map['exercise_type_id'] as int,
        name: map['exercise_type_name'] as String,
        description: map['exercise_type_description'] as String?,
      );

      // Create the Exercise domain entity with the complete exercise type
      return Exercise(
        id: map['id'] as int,
        exerciseType: exerciseType,
        order: map['order_index'] as int,
        sets: [], // Sets would be loaded separately if needed
        notes: map['notes'] as String?,
      );
    }).toList();
  }

  /// Update the order of exercises within a workout
  /// This handles drag-and-drop reordering scenarios
  Future<void> reorderExercises(int workoutId, List<int> exerciseIds) async {
    // Use a transaction to ensure all updates succeed or fail together
    final database = await _db.database;
    await database.transaction((txn) async {
      for (int i = 0; i < exerciseIds.length; i++) {
        await txn.update(
          tableName,
          {'order_index': i + 1}, // Order starts at 1, not 0
          where: 'id = ? AND workout_id = ?',
          whereArgs: [exerciseIds[i], workoutId],
        );
      }
    });
  }

  /// Get the next order number for a new exercise in a workout
  /// This ensures new exercises are added at the end of the sequence
  Future<int> getNextOrderForWorkout(int workoutId) async {
    final database = await _db.database;
    final result = await database.rawQuery(
      '''
      SELECT COALESCE(MAX(order_index), 0) + 1 as next_order 
      FROM $tableName 
      WHERE workout_id = ?
    ''',
      [workoutId],
    );

    return result.first['next_order'] as int;
  }

  /// Get the count of exercises in a specific workout
  /// Useful for UI indicators and validation
  Future<int> getCountByWorkoutId(int workoutId) async {
    final database = await _db.database;
    final result = await database.rawQuery(
      '''
      SELECT COUNT(*) as count 
      FROM $tableName 
      WHERE workout_id = ?
    ''',
      [workoutId],
    );

    return result.first['count'] as int;
  }

  /// Delete all exercises for a specific workout
  /// This is typically called when a workout is deleted
  Future<int> deleteByWorkoutId(int workoutId) async {
    final database = await _db.database;
    return await database.delete(tableName, where: 'workout_id = ?', whereArgs: [workoutId]);
  }

  /// Get all exercises that use a specific exercise type
  /// This is useful for understanding the impact before deleting an exercise type
  Future<List<ExerciseModel>> getByExerciseTypeId(int exerciseTypeId) async {
    final database = await _db.database;
    final maps = await database.query(
      tableName,
      where: 'exercise_type_id = ?',
      whereArgs: [exerciseTypeId],
      orderBy: 'workout_id ASC, order_index ASC',
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).toList();
  }
}
