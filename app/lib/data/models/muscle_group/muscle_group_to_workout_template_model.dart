import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

const muscleGroupToWorkoutTemplateTable = 'muscle_group_to_workout_template';

class MuscleGroupToWorkoutTemplateFields {
  static final List<String> values = [id, muscleGroupId, workoutTemplateId];

  static final String id = 'id';
  static final String muscleGroupId = 'muscle_group_id';
  static final String workoutTemplateId = 'workout_template_id';
}

class MuscleGroupToWorkoutTemplateModel implements Model {
  @override
  final String id;
  final String muscleGroupId;
  final String workoutTemplateId;

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
    final id = map[MuscleGroupToWorkoutTemplateFields.id];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[MuscleGroupToWorkoutTemplateFields.muscleGroupId];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final workoutTemplateId =
        map[MuscleGroupToWorkoutTemplateFields.workoutTemplateId];
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
      MuscleGroupToWorkoutTemplateFields.id: id,
      MuscleGroupToWorkoutTemplateFields.muscleGroupId: muscleGroupId,
      MuscleGroupToWorkoutTemplateFields.workoutTemplateId: workoutTemplateId,
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
