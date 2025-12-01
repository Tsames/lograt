import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseType {
  final String id;
  final String name;
  final List<MuscleGroup> muscleGroups;
  final String? description;

  ExerciseType({
    String? id,
    required this.name,
    List<MuscleGroup>? muscleGroups,
    this.description,
  }) : id = id ?? uuidV7(),
       muscleGroups = muscleGroups ?? const <MuscleGroup>[];

  ExerciseType copyWith({
    String? id,
    String? name,
    List<MuscleGroup>? muscleGroups,
    String? description,
  }) {
    return ExerciseType(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseType && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseType(id: $id, name: $name, muscleGroups: $muscleGroups, description: $description)';
}
