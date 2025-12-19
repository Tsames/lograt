import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

const muscleGroupToExerciseTypeTable = 'muscle_group_to_exercise_type';

class MuscleGroupToExerciseTypeFields {
  static final List<String> values = [id, muscleGroupId, exerciseTypeId];

  static final String id = 'id';
  static final String muscleGroupId = 'muscle_group_id';
  static final String exerciseTypeId = 'exercise_type_id';
}

class MuscleGroupToExerciseTypeModel implements Model {
  @override
  final String id;
  final String muscleGroupId;
  final String exerciseTypeId;

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
    final id = map[MuscleGroupToExerciseTypeFields.id];
    if (id == null || id is! String) return null;
    final muscleGroupId = map[MuscleGroupToExerciseTypeFields.muscleGroupId];
    if (muscleGroupId == null || muscleGroupId is! String) return null;
    final exerciseTypeId = map[MuscleGroupToExerciseTypeFields.exerciseTypeId];
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
      MuscleGroupToExerciseTypeFields.id: id,
      MuscleGroupToExerciseTypeFields.muscleGroupId: muscleGroupId,
      MuscleGroupToExerciseTypeFields.exerciseTypeId: exerciseTypeId,
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
