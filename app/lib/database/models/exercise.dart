import 'package:lograt/database/app_database.dart';
import 'package:lograt/services/uuid.dart';

class Exercise {
  final String id;
  final String name;
  final List<MuscleGroupRow> muscleGroups;
  final String? description;

  Exercise({
    String? id,
    required this.name,
    List<MuscleGroupRow>? muscleGroups,
    this.description,
  }) : id = id ?? uuid.v7(),
       muscleGroups = muscleGroups ?? const <MuscleGroupRow>[];

  Exercise copyWith({
    String Function()? id,
    String Function()? name,
    List<MuscleGroupRow> Function()? muscleGroups,
    String? Function()? description,
  }) {
    return Exercise(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      muscleGroups: muscleGroups != null ? muscleGroups() : this.muscleGroups,
      description: description != null ? description() : this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Exercise(id: $id, name: $name, muscleGroups: $muscleGroups, description: $description)';
}
