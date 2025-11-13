import 'package:lograt/util/uuidv7.dart';

import 'exercise.dart';

class Workout {
  final String id; // UUIDv7 generated primary key
  final String? name;
  final DateTime date;
  final List<Exercise> exercises;
  final String? notes;

  Workout({
    String? id,
    this.name,
    DateTime? date,
    this.exercises = const <Exercise>[],
    this.notes,
  }) : id = id ?? uuidV7(),
       date = date ?? DateTime.now();

  Workout copyWith({
    String? id,
    String? name,
    DateTime? date,
    List<Exercise>? exercises,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "Workout(id: $id, name: $name, date: ${date.toIso8601String()}, exercises: $exercises, notes: $notes)";
}
