/// Represents a summary of a workout.
/// To be displayed as a list of recent workouts on the home page.
class WorkoutSummary {
  final int? id; //SQLite generated primary key
  final String name;
  final DateTime createdOn;

  const WorkoutSummary({this.id, required this.name, required this.createdOn});

  WorkoutSummary copyWith({int? id, String? name, DateTime? createdOn}) {
    return WorkoutSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  bool get isRecent => DateTime.now().difference(createdOn).inDays < 14;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSummary &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "WorkoutSummary{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }";
}
