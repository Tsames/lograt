import 'exercise.dart';

/// Represents a specific workout
class Workout {
  final int? id; //SQLite generated primary key
  final String name;
  final DateTime createdOn;
  final List<Exercise> exercises;

  const Workout(this.name, this.createdOn, this.exercises, {this.id});

  Workout copyWith({
    int? id,
    String? name,
    DateTime? createdOn,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      name ?? this.name,
      createdOn ?? this.createdOn,
      exercises ?? this.exercises,
    );
  }

  int get exerciseCount => exercises.length;

  bool get isRecent => DateTime.now().difference(createdOn).inDays < 14;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Workout && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "Workout{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }";
}
