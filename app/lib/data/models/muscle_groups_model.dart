import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/util/uuidv7.dart';

const muscleGroupsTable = 'muscle_groups';
const muscleGroupsToWorkoutsTable = 'muscle_groups_to_workouts';
const muscleGroupsToExerciseTypesTable = 'muscle_groups_to_exercise_types';

class MuscleGroupsFields {
  static final List<String> values = [id, label, description];

  static final String id = 'id';
  static final String label = 'label';
  static final String description = 'description';
}

class MuscleGroupsModel {
  final String id;
  final String label;
  final String? description;

  const MuscleGroupsModel({
    required this.id,
    required this.label,
    this.description,
  });

  MuscleGroupsModel.forTest({required String label, String? description})
    : this(id: uuidV7(), label: label, description: description);

  MuscleGroupsModel.fromEntity(MuscleGroup muscleGroup)
    : this(
        id: muscleGroup.id,
        label: muscleGroup.label,
        description: muscleGroup.description,
      );

  MuscleGroup toEntity() {
    return MuscleGroup(id: id, label: label, description: description);
  }

  static MuscleGroupsModel? fromMap(Map<String, dynamic> map) {
    final id = map[MuscleGroupsFields.id];
    if (id == null || id is! String) return null;
    final label = map[MuscleGroupsFields.label];
    if (label == null || label is! String) return null;
    final description = map[MuscleGroupsFields.description];
    if (description != null && description is! String) return null;
    return MuscleGroupsModel(id: id, label: label, description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      MuscleGroupsFields.id: id,
      MuscleGroupsFields.label: label,
      MuscleGroupsFields.description: description,
    };
  }

  MuscleGroupsModel copyWith({String? id, String? label, String? description}) {
    return MuscleGroupsModel(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupsModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupsModel(id: $id, label: $label, description: $description)';
}
