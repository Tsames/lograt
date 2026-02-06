import 'package:lograt/data/dao/relationship_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_exercise_type_model.dart';

class MuscleGroupToExerciseTypeDao
    extends RelationshipDao<MuscleGroupToExerciseTypeModel> {
  MuscleGroupToExerciseTypeDao(AppDatabase db)
    : super(
        db: db,
        tableName: MuscleGroupToExerciseTypeModel.tableName,
        relationshipIdFieldName: MuscleGroupToExerciseTypeModel.idFieldName,
        leftModelIdFieldName:
            MuscleGroupToExerciseTypeModel.muscleGroupIdFieldName,
        rightModelIdFieldName:
            MuscleGroupToExerciseTypeModel.exerciseTypeIdFieldName,
      );

  /// Deletes muscle group relationships for a exercise type.
  ///
  /// If [muscleGroupIds] is null, deletes ALL muscle groups for the exercise type.
  /// If [muscleGroupIds] is provided, deletes only those specific muscle groups.
  ///
  /// Throws an exception if:
  /// - No relationships exist for the exercise type (when deleting all)
  /// - Any specified muscle group relationship doesn't exist (when deleting specific ones)
  // Future<int> deleteMuscleGroupsForExerciseType(
  //   String exerciseTypeId, {
  //   List<String>? muscleGroupIds,
  //   Transaction? txn,
  // }) async {
  //   Future<int> executeDelete(Transaction transaction) async {
  //     // Case 1: Delete all muscle groups for the exercise type
  //     if (muscleGroupIds == null) {
  //       final rowsDeleted = await transaction.delete(
  //         _tableName,
  //         where: '${MuscleGroupToExerciseTypeFields.exerciseTypeId} = ?',
  //         whereArgs: [exerciseTypeId],
  //       );
  //
  //       if (rowsDeleted == 0) {
  //         throw Exception('Cannot delete muscle groups for exercise type ($exerciseTypeId): no relationships exist');
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
  //       final exists = await relationshipExists(muscleGroupId, exerciseTypeId, transaction);
  //       if (!exists) {
  //         throw Exception(
  //           'Cannot delete muscle group ($muscleGroupId) to exercise type ($exerciseTypeId) relationship: does not exist',
  //         );
  //       }
  //     }
  //
  //     // All relationships exist, proceed with deletion
  //     final placeholders = List.filled(muscleGroupIds.length, '?').join(', ');
  //     return await transaction.delete(
  //       _tableName,
  //       where:
  //           '${MuscleGroupToExerciseTypeFields.exerciseTypeId} = ? AND ${MuscleGroupToExerciseTypeFields.muscleGroupId} IN ($placeholders)',
  //       whereArgs: [exerciseTypeId, ...muscleGroupIds],
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
