import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/util/uuidv7.dart';

const muscleGroupTable = 'muscle_groups';
const muscleGroupToWorkoutTemplateTable = 'muscle_group_to_workout_template';
const muscleGroupToExerciseTypeTable = 'muscle_group_to_exercise_type';

class MuscleGroupFields {
  static final List<String> values = [id, label, description];

  static final String id = 'id';
  static final String label = 'label';
  static final String description = 'description';
}

class MuscleGroupToWorkoutTemplateFields {
  static final List<String> values = [id, muscleGroupId, workoutTemplateId];

  static final String id = 'id';
  static final String muscleGroupId = 'muscle_group_id';
  static final String workoutTemplateId = 'workout_template_id';
}

class MuscleGroupToExerciseTypeFields {
  static final List<String> values = [id, muscleGroupId, exerciseTypeId];

  static final String id = 'id';
  static final String muscleGroupId = 'muscle_group_id';
  static final String exerciseTypeId = 'exercise_type_id';
}

class MuscleGroupModel {
  final String id;
  final String label;
  final String? description;

  const MuscleGroupModel({
    required this.id,
    required this.label,
    this.description,
  });

  MuscleGroupModel.forTest({required String label, String? description})
    : this(id: uuidV7(), label: label, description: description);

  MuscleGroupModel.fromEntity(MuscleGroup muscleGroup)
    : this(
        id: muscleGroup.id,
        label: muscleGroup.label,
        description: muscleGroup.description,
      );

  MuscleGroup toEntity() {
    return MuscleGroup(id: id, label: label, description: description);
  }

  static MuscleGroupModel? fromMap(Map<String, dynamic> map) {
    final id = map[MuscleGroupFields.id];
    if (id == null || id is! String) return null;
    final label = map[MuscleGroupFields.label];
    if (label == null || label is! String) return null;
    final description = map[MuscleGroupFields.description];
    if (description != null && description is! String) return null;
    return MuscleGroupModel(id: id, label: label, description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      MuscleGroupFields.id: id,
      MuscleGroupFields.label: label,
      MuscleGroupFields.description: description,
    };
  }

  MuscleGroupModel copyWith({String? id, String? label, String? description}) {
    return MuscleGroupModel(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupModel(id: $id, label: $label, description: $description)';
}
