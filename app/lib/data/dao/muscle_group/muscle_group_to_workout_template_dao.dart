import 'package:lograt/data/dao/relationship_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_template_model.dart';

class MuscleGroupToWorkoutTemplateDao
    extends RelationshipDao<MuscleGroupToWorkoutTemplateModel> {
  MuscleGroupToWorkoutTemplateDao(AppDatabase db)
    : super(
        db: db,
        tableName: MuscleGroupToWorkoutTemplateModel.tableName,
        relationshipIdFieldName: MuscleGroupToWorkoutTemplateModel.idFieldName,
        leftModelIdFieldName:
            MuscleGroupToWorkoutTemplateModel.muscleGroupIdFieldName,
        rightModelIdFieldName:
            MuscleGroupToWorkoutTemplateModel.workoutTemplateIdFieldName,
      );

  /// Deletes muscle group relationships for a workout template.
  ///
  /// If [muscleGroupIds] is null, deletes ALL muscle groups for the workout template.
  /// If [muscleGroupIds] is provided, deletes only those specific muscle groups.
  ///
  /// Throws an exception if:
  /// - No relationships exist for the workout template (when deleting all)
  /// - Any specified muscle group relationship doesn't exist (when deleting specific ones)
  // Future<int> deleteMuscleGroupsForWorkoutTemplate(
  //   String workoutTemplateId, {
  //   List<String>? muscleGroupIds,
  //   Transaction? txn,
  // }) async {
  //   Future<int> executeDelete(Transaction transaction) async {
  //     // Case 1: Delete all muscle groups for the workout template
  //     if (muscleGroupIds == null) {
  //       final rowsDeleted = await transaction.delete(
  //         _tableName,
  //         where: '${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ?',
  //         whereArgs: [workoutTemplateId],
  //       );
  //
  //       if (rowsDeleted == 0) {
  //         throw Exception(
  //           'Cannot delete muscle groups for workout template ($workoutTemplateId): no relationships exist',
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
  //         workoutTemplateId,
  //         transaction,
  //       );
  //       if (!exists) {
  //         throw Exception(
  //           'Cannot delete muscle group ($muscleGroupId) to workout template ($workoutTemplateId) relationship: does not exist',
  //         );
  //       }
  //     }
  //
  //     // All relationships exist, proceed with deletion
  //     final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
  //     return await transaction.delete(
  //       _tableName,
  //       where:
  //           '${MuscleGroupToWorkoutTemplateFields.workoutTemplateId} = ? AND ${MuscleGroupToWorkoutTemplateFields.muscleGroupId} IN ($placeholders)',
  //       whereArgs: [workoutTemplateId, ...muscleGroupIds],
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
