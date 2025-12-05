import 'package:lograt/util/uuidv7.dart';

const muscleGroupToWorkoutTable = 'muscle_group_to_workout';

class MuscleGroupToWorkoutFields {
  static final List<String> values = [id, muscleGroupId, workoutId];

  static final String id = 'id';
  static final String muscleGroupId = 'muscle_group_id';
  static final String workoutId = 'workout_id';
}

class MuscleGroupToWorkoutModel {
  final String id;
  final String muscleGroupId;
  final String workoutId;

  const MuscleGroupToWorkoutModel({
    required this.id,
    required this.muscleGroupId,
    required this.workoutId,
  });

  MuscleGroupToWorkoutModel.forTest({
    required String muscleGroupId,
    required String workoutId,
  }) : this(id: uuidV7(), muscleGroupId: muscleGroupId, workoutId: workoutId);

  static MuscleGroupToWorkoutModel? fromMap(Map<String, dynamic> map) {
    final id = map[MuscleGroupToWorkoutFields.id];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[MuscleGroupToWorkoutFields.muscleGroupId];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final workoutId = map[MuscleGroupToWorkoutFields.workoutId];
    if (workoutId != null && workoutId is! String) return null;
    return MuscleGroupToWorkoutModel(
      id: id,
      muscleGroupId: muscleGroupId,
      workoutId: workoutId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      MuscleGroupToWorkoutFields.id: id,
      MuscleGroupToWorkoutFields.muscleGroupId: muscleGroupId,
      MuscleGroupToWorkoutFields.workoutId: workoutId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupToWorkoutModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupModel(id: $id, muscleGroupId: $muscleGroupId, workoutId: $workoutId)';
}
