import 'exercise.dart';

/// Represents a specific workout
class Workout {
  final int? id; //SQLite generated primary key
  final String name;
  final DateTime createdOn;
  final String? description;
  final List<Exercise> exercises;

  const Workout({
    this.id,
    required this.name,
    required this.createdOn,
    required this.description,
    required this.exercises,
  });

  Workout copyWith({int? id, String? name, DateTime? createdOn, String? description, List<Exercise>? exercises}) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      createdOn: createdOn ?? this.createdOn,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
    );
  }

  bool get isRecent => DateTime.now().difference(createdOn).inDays < 14;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Workout && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "Workout{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }";
}
