import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/relationship.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:lograt/util/uuidv7.dart';

class MuscleGroupToWorkoutModel
    implements Relationship<MuscleGroupModel, WorkoutModel> {
  @override
  final String id;
  final String muscleGroupId;
  final String workoutId;

  static final tableName = 'muscle_group_to_workout';
  static final idFieldName = 'id';
  static final muscleGroupIdFieldName = 'muscle_group_id';
  static final workoutIdFieldName = 'workout_id';

  @override
  String get leftId => muscleGroupId;

  @override
  String get rightId => workoutId;

  const MuscleGroupToWorkoutModel._({
    required this.id,
    required this.muscleGroupId,
    required this.workoutId,
  });

  MuscleGroupToWorkoutModel.createWithId({
    required String muscleGroupId,
    required String workoutId,
  }) : this._(id: uuidV7(), muscleGroupId: muscleGroupId, workoutId: workoutId);

  static MuscleGroupToWorkoutModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[muscleGroupIdFieldName];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final workoutId = map[workoutIdFieldName];
    if (workoutId != null && workoutId is! String) return null;
    return MuscleGroupToWorkoutModel._(
      id: id,
      muscleGroupId: muscleGroupId,
      workoutId: workoutId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      muscleGroupIdFieldName: muscleGroupId,
      workoutIdFieldName: workoutId,
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
