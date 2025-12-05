import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupToWorkoutDao {
  final AppDatabase _db;
  static const String _tableName = muscleGroupToWorkoutTable;

  MuscleGroupToWorkoutDao(this._db);

  Future<bool> relationshipExists(
    String muscleGroupId,
    String workoutId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      where:
          '${MuscleGroupToWorkoutFields.muscleGroupId} = ? AND ${MuscleGroupToWorkoutFields.workoutId} = ?',
      whereArgs: [muscleGroupId, workoutId],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  Future<List<MuscleGroupToWorkoutModel>> getRelationshipsByWorkoutIds(
    List<String> workoutIds, [
    Transaction? txn,
  ]) async {
    if (workoutIds.isEmpty) {
      throw Exception(
        'Cannot retrieve muscle group to workout relationships by workoutIds if no workoutIds are given.',
      );
    }
    final DatabaseExecutor executor = txn ?? await _db.database;

    final placeholders = List.filled(workoutIds.length, '?').join(', ');
    final records = await executor.query(
      _tableName,
      where: '${MuscleGroupToWorkoutFields.workoutId} IN ($placeholders)',
      whereArgs: [...workoutIds],
    );

    return records
        .map((record) => MuscleGroupToWorkoutModel.fromMap(record))
        .nonNulls
        .toList();
  }

  Future<void> insertRelationship({
    required String muscleGroupId,
    required String workoutId,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(_tableName, {
      MuscleGroupToWorkoutFields.id: uuidV7(),
      MuscleGroupToWorkoutFields.muscleGroupId: muscleGroupId,
      MuscleGroupToWorkoutFields.workoutId: workoutId,
    }, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> batchInsertRelationships(
    List<({String workoutId, String muscleGroupId})> relationships, [
    Transaction? txn,
  ]) async {
    if (relationships.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final relationship in relationships) {
      batch.insert(_tableName, {
        MuscleGroupToWorkoutFields.id: uuidV7(),
        MuscleGroupToWorkoutFields.muscleGroupId: relationship.muscleGroupId,
        MuscleGroupToWorkoutFields.workoutId: relationship.workoutId,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete(
    String muscleGroupId,
    String workoutId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final rowsDeleted = await executor.delete(
      _tableName,
      where:
          '${MuscleGroupToWorkoutFields.muscleGroupId} = ? AND ${MuscleGroupToWorkoutFields.workoutId} = ?',
      whereArgs: [muscleGroupId, workoutId],
    );

    if (rowsDeleted == 0) {
      throw Exception(
        'Cannot delete muscle group ($muscleGroupId) to workout ($workoutId) relationship: does not exist',
      );
    }
  }

  /// Deletes muscle group relationships for a workout.
  ///
  /// If [muscleGroupIds] is null, deletes ALL muscle groups for the workout.
  /// If [muscleGroupIds] is provided, deletes only those specific muscle groups.
  ///
  /// Throws an exception if:
  /// - No relationships exist for the workout (when deleting all)
  /// - Any specified muscle group relationship doesn't exist (when deleting specific ones)
  Future<int> deleteMuscleGroupsForWorkout(
    String workoutId, {
    List<String>? muscleGroupIds,
    Transaction? txn,
  }) async {
    Future<int> executeDelete(Transaction transaction) async {
      // Case 1: Delete all muscle groups for the workout
      if (muscleGroupIds == null) {
        final rowsDeleted = await transaction.delete(
          _tableName,
          where: '${MuscleGroupToWorkoutFields.workoutId} = ?',
          whereArgs: [workoutId],
        );

        if (rowsDeleted == 0) {
          throw Exception(
            'Cannot delete muscle groups for workout ($workoutId): no relationships exist',
          );
        }

        return rowsDeleted;
      }

      // Case 2: Delete specific muscle groups
      if (muscleGroupIds.isEmpty) return 0;

      // Validate all relationships exist before deleting
      for (final muscleGroupId in muscleGroupIds) {
        final exists = await relationshipExists(
          muscleGroupId,
          workoutId,
          transaction,
        );
        if (!exists) {
          throw Exception(
            'Cannot delete muscle group ($muscleGroupId) to workout ($workoutId) relationship: does not exist',
          );
        }
      }

      // All relationships exist, proceed with deletion
      final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
      return await transaction.delete(
        _tableName,
        where:
            '${MuscleGroupToWorkoutFields.workoutId} = ? AND ${MuscleGroupToWorkoutFields.muscleGroupId} IN ($placeholders)',
        whereArgs: [workoutId, ...muscleGroupIds],
      );
    }

    if (txn != null) {
      return await executeDelete(txn);
    } else {
      final db = await _db.database;
      return await db.transaction((transaction) => executeDelete(transaction));
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(_tableName);
  }
}
