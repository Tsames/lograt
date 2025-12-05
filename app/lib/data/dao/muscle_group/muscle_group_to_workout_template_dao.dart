import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupToWorkoutTemplateDao {
  final AppDatabase _db;
  static const String _tableName = muscleGroupToWorkoutTemplateTable;

  MuscleGroupToWorkoutTemplateDao(this._db);

  Future<bool> relationshipExists(
    String muscleGroupId,
    String workoutTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      _tableName,
      where:
          '${MuscleGroupToWorkoutTemplateFields.muscleGroupId} = ? AND ${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ?',
      whereArgs: [muscleGroupId, workoutTemplateId],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  Future<void> insertRelationship({
    required String muscleGroupId,
    required String workoutTemplateId,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(_tableName, {
      MuscleGroupToWorkoutTemplateFields.id: uuidV7(),
      MuscleGroupToWorkoutTemplateFields.muscleGroupId: muscleGroupId,
      MuscleGroupToWorkoutTemplateFields.workoutTemplateId: workoutTemplateId,
    }, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> batchInsertRelationships(
    List<({String workoutTemplateId, String muscleGroupId})> relationships, [
    Transaction? txn,
  ]) async {
    if (relationships.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final relationship in relationships) {
      batch.insert(_tableName, {
        MuscleGroupToWorkoutTemplateFields.id: uuidV7(),
        MuscleGroupToWorkoutTemplateFields.muscleGroupId:
            relationship.muscleGroupId,
        MuscleGroupToWorkoutTemplateFields.workoutTemplateId:
            relationship.workoutTemplateId,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete(
    String muscleGroupId,
    String workoutTemplateId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final rowsDeleted = await executor.delete(
      _tableName,
      where:
          '${MuscleGroupToWorkoutTemplateFields.muscleGroupId} = ? AND ${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ?',
      whereArgs: [muscleGroupId, workoutTemplateId],
    );

    if (rowsDeleted == 0) {
      throw Exception(
        'Cannot delete muscle group ($muscleGroupId) to workout template ($workoutTemplateId) relationship: does not exist',
      );
    }
  }

  /// Deletes muscle group relationships for a workout template.
  ///
  /// If [muscleGroupIds] is null, deletes ALL muscle groups for the workout template.
  /// If [muscleGroupIds] is provided, deletes only those specific muscle groups.
  ///
  /// Throws an exception if:
  /// - No relationships exist for the workout template (when deleting all)
  /// - Any specified muscle group relationship doesn't exist (when deleting specific ones)
  Future<int> deleteMuscleGroupsForWorkoutTemplate(
    String workoutTemplateId, {
    List<String>? muscleGroupIds,
    Transaction? txn,
  }) async {
    Future<int> executeDelete(Transaction transaction) async {
      // Case 1: Delete all muscle groups for the workout template
      if (muscleGroupIds == null) {
        final rowsDeleted = await transaction.delete(
          _tableName,
          where: '${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ?',
          whereArgs: [workoutTemplateId],
        );

        if (rowsDeleted == 0) {
          throw Exception(
            'Cannot delete muscle groups for workout template ($workoutTemplateId): no relationships exist',
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
          workoutTemplateId,
          transaction,
        );
        if (!exists) {
          throw Exception(
            'Cannot delete muscle group ($muscleGroupId) to workout template ($workoutTemplateId) relationship: does not exist',
          );
        }
      }

      // All relationships exist, proceed with deletion
      final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
      return await transaction.delete(
        _tableName,
        where:
            '${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ? AND ${MuscleGroupToWorkoutTemplateFields.muscleGroupId} IN ($placeholders)',
        whereArgs: [workoutTemplateId, ...muscleGroupIds],
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
