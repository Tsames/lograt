import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

class WorkoutTemplate {
  final String id;
  final DateTime date;
  final List<ExerciseTemplate> exercises;
  final String? title;
  final String? notes;

  WorkoutTemplate({
    String? id,
    DateTime? date,
    List<ExerciseTemplate>? exercises,
    this.title,
    this.notes,
  }) : id = id ?? uuidV7(),
       date = date ?? DateTime.now(),
       exercises = exercises ?? const <ExerciseTemplate>[];

  WorkoutTemplate copyWith({
    String? id,
    DateTime? date,
    List<ExerciseTemplate>? exercises,
    String? title,
    String? notes,
  }) {
    return WorkoutTemplate(
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
    return other is WorkoutTemplate && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WorkoutTemplate(id: $id, date: ${date.toHumanFriendlyFormat()}, exercises: $exercises, title: $title, notes: $notes)';
}
