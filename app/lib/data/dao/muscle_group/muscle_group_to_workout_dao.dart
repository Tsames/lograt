import 'package:lograt/data/dao/many_to_many_relationship_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:sqflite/sqflite.dart';

class MuscleGroupToWorkoutDao
    extends ManyToManyRelationshipDao<MuscleGroupToWorkoutModel> {
  late final _tableName = MuscleGroupToWorkoutModel.tableName;

  MuscleGroupToWorkoutDao(AppDatabase db) : super(db: db);

  Future<List<MuscleGroupToWorkoutModel>> getRelationshipsByWorkoutIds(
    List<String> workoutIds, [
    Transaction? txn,
  ]) async {
    if (workoutIds.isEmpty) {
      throw Exception(
        'Cannot retrieve muscle group to workout relationships by workoutIds if no workoutIds are given.',
      );
    }
    final DatabaseExecutor executor = txn ?? await db.database;

    final placeholders = List.filled(workoutIds.length, '?').join(', ');
    final records = await executor.query(
      _tableName,
      where:
          '${MuscleGroupToWorkoutModel.workoutIdFieldName} IN ($placeholders)',
      whereArgs: [...workoutIds],
    );

    return records
        .map((record) => MuscleGroupToWorkoutModel.fromMap(record))
        .nonNulls
        .toList();
  }

  /// Deletes muscle group relationships for a workout.
  ///
  /// If [muscleGroupIds] is null, deletes ALL muscle groups for the workout.
  /// If [muscleGroupIds] is provided, deletes only those specific muscle groups.
  ///
  /// Throws an exception if:
  /// - No relationships exist for the workout (when deleting all)
  /// - Any specified muscle group relationship doesn't exist (when deleting specific ones)
  // Future<int> deleteMuscleGroupsForWorkout(
  //   String workoutId, {
  //   List<String>? muscleGroupIds,
  //   Transaction? txn,
  // }) async {
  //   Future<int> executeDelete(Transaction transaction) async {
  //     // Case 1: Delete all muscle groups for the workout
  //     if (muscleGroupIds == null) {
  //       final rowsDeleted = await transaction.delete(
  //         _tableName,
  //         where: '${MuscleGroupToWorkoutFields.workoutId} = ?',
  //         whereArgs: [workoutId],
  //       );
  //
  //       if (rowsDeleted == 0) {
  //         throw Exception(
  //           'Cannot delete muscle groups for workout ($workoutId): no relationships exist',
  //         );
  //       }
  //
  //       return rowsDeleted;
  //     }
  //
  //     // Case 2: Delete specific muscle groups
  //     if (muscleGroupIds.isEmpty) return 0;
  //
  //     // Validate all relationships exist before deleting
  //     for (final muscleGroupId in muscleGroupIds) {
  //       final exists = await relationshipExists(
  //         muscleGroupId,
  //         workoutId,
  //         transaction,
  //       );
  //       if (!exists) {
  //         throw Exception(
  //           'Cannot delete muscle group ($muscleGroupId) to workout ($workoutId) relationship: does not exist',
  //         );
  //       }
  //     }
  //
  //     // All relationships exist, proceed with deletion
  //     final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
  //     return await transaction.delete(
  //       _tableName,
  //       where:
  //           '${MuscleGroupToWorkoutFields.workoutId} = ? AND ${MuscleGroupToWorkoutFields.muscleGroupId} IN ($placeholders)',
  //       whereArgs: [workoutId, ...muscleGroupIds],
  //     );
  //   }
  //
  //   if (txn != null) {
  //     return await executeDelete(txn);
  //   } else {
  //     final db = await _db.database;
  //     return await db.transaction((transaction) => executeDelete(transaction));
  //   }
  // }
}
