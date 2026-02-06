import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:lograt/util/uuidv7.dart';

class MuscleGroupToWorkoutTemplateModel
    implements Relationship<MuscleGroupModel, WorkoutTemplateModel> {
  @override
  final String id;
  final String muscleGroupId;
  final String workoutTemplateId;

  static final tableName = 'muscle_group_to_workout_template';
  static final String idFieldName = 'id';
  static final String muscleGroupIdFieldName = 'muscle_group_id';
  static final String workoutTemplateIdFieldName = 'workout_template_id';

  @override
  String get leftId => muscleGroupId;

  @override
  String get rightId => workoutTemplateId;

  @override
  String get nameOfTable => tableName;

  @override
  String get idField => idFieldName;

  @override
  String get leftModelIdField => muscleGroupIdFieldName;

  @override
  String get rightModelIdField => workoutTemplateIdFieldName;

  const MuscleGroupToWorkoutTemplateModel._({
    required this.id,
    required this.muscleGroupId,
    required this.workoutTemplateId,
  });

  MuscleGroupToWorkoutTemplateModel.createWithId({
    required String muscleGroupId,
    required String workoutTemplateId,
  }) : this._(
         id: uuidV7(),
         muscleGroupId: muscleGroupId,
         workoutTemplateId: workoutTemplateId,
       );

  static MuscleGroupToWorkoutTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[muscleGroupIdFieldName];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final workoutTemplateId = map[workoutTemplateIdFieldName];
    if (workoutTemplateId != null && workoutTemplateId is! String) return null;
    return MuscleGroupToWorkoutTemplateModel._(
      id: id,
      muscleGroupId: muscleGroupId,
      workoutTemplateId: workoutTemplateId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      muscleGroupIdFieldName: muscleGroupId,
      workoutTemplateIdFieldName: workoutTemplateId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupToWorkoutTemplateModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupToWorkoutTemplateModel(id: $id, muscleGroupId: $muscleGroupId, workoutTemplateId: $workoutTemplateId)';
}
