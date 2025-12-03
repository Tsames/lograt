import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
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

  Future<int> deleteMuscleGroupsForWorkout(
    String workoutId,
    List<String> muscleGroupIds, [
    Transaction? txn,
  ]) async {
    if (muscleGroupIds.isEmpty) return 0;

    final DatabaseExecutor executor = txn ?? await _db.database;

    // Create placeholders for the IN clause: (?, ?, ?)
    final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');

    return await executor.delete(
      _tableName,
      where:
          '${MuscleGroupToWorkoutFields.workoutId} = ? AND ${MuscleGroupToWorkoutFields.muscleGroupId} IN ($placeholders)',
      whereArgs: [workoutId, ...muscleGroupIds],
    );
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(_tableName);
  }
}
