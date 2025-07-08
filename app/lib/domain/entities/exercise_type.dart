/// Represents a specific type of exercise such as 'Push ups' or 'Squats'
class ExerciseType {
  final int? id; // SQLite generated primary key
  final String name; // Name of the exercise
  final String? description;

  const ExerciseType({required this.id, required this.name, this.description});

  ExerciseType copyWith({int? id, String? name, String? description}) {
    return ExerciseType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseType &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ExerciseType{ id: ${id ?? 'null'}, name: $name }';
}
