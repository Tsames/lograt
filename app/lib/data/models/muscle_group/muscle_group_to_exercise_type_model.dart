import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/util/uuidv7.dart';

class MuscleGroupToExerciseTypeModel
    implements Relationship<MuscleGroupModel, ExerciseTypeModel> {
  @override
  final String id;
  final String muscleGroupId;
  final String exerciseTypeId;

  static const tableName = 'muscle_group_to_exercise_type';
  static final idFieldName = 'id';
  static final muscleGroupIdFieldName = 'muscle_group_id';
  static final exerciseTypeIdFieldName = 'exercise_type_id';

  @override
  String get leftId => muscleGroupId;

  @override
  String get rightId => exerciseTypeId;

  @override
  String get nameOfTable => tableName;

  @override
  String get idField => idFieldName;

  @override
  String get leftModelIdField => muscleGroupIdFieldName;

  @override
  String get rightModelIdField => exerciseTypeIdFieldName;

  const MuscleGroupToExerciseTypeModel._({
    required this.id,
    required this.muscleGroupId,
    required this.exerciseTypeId,
  });

  MuscleGroupToExerciseTypeModel.createWithId({
    required String muscleGroupId,
    required String exerciseTypeId,
  }) : this._(
         id: uuidV7(),
         muscleGroupId: muscleGroupId,
         exerciseTypeId: exerciseTypeId,
       );

  static MuscleGroupToExerciseTypeModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[muscleGroupIdFieldName];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final exerciseTypeId = map[exerciseTypeIdFieldName];
    if (exerciseTypeId != null && exerciseTypeId is! String) return null;
    return MuscleGroupToExerciseTypeModel._(
      id: id,
      muscleGroupId: muscleGroupId,
      exerciseTypeId: exerciseTypeId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      muscleGroupIdFieldName: muscleGroupId,
      exerciseTypeIdFieldName: exerciseTypeId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupToExerciseTypeModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupToExerciseTypeModel(id: $id, muscleGroupId: $muscleGroupId, exerciseTypeId: $exerciseTypeId)';
}
