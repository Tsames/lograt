import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

import 'exercise.dart';

class Workout {
  final String id;
  final DateTime date;
  final List<Exercise> exercises;
  final String? title;
  final String? notes;

  Workout({
    String? id,
    DateTime? date,
    List<Exercise>? exercises,
    this.title,
    this.notes,
  }) : id = id ?? uuidV7(),
       date = date ?? DateTime.now(),
       exercises = exercises ?? const <Exercise>[];

  Workout copyWith({
    String? id,
    DateTime? date,
    List<Exercise>? exercises,
    String? title,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      title: title ?? this.title,
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
      "Workout(id: $id, date: ${date.toHumanFriendlyFormat()}, exercises: $exercises, title: $title, notes: $notes)";
}
