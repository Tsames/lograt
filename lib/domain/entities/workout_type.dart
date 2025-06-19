class ExerciseType {
  final String id;
  final String name;
  final String? description;

  const ExerciseType({required this.id, required this.name, this.description});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExerciseType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ExerciseType(id: $id, name: $name)';
}
