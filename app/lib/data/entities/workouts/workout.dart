import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

class Workout {
  final String id;
  final DateTime date;
  final List<Exercise> exercises;
  final List<MuscleGroup> muscleGroups;
  final WorkoutTemplate? template;
  final String? title;
  final String? notes;

  Workout({
    String? id,
    DateTime? date,
    List<Exercise>? exercises,
    List<MuscleGroup>? muscleGroups,
    this.template,
    this.title,
    this.notes,
  }) : id = id ?? uuidV7(),
       date = date ?? DateTime.now(),
       exercises = exercises ?? const <Exercise>[],
       muscleGroups = muscleGroups ?? const <MuscleGroup>[];

  Workout copyWith({
    String? id,
    DateTime? date,
    List<Exercise>? exercises,
    List<MuscleGroup>? muscleGroups,
    WorkoutTemplate? template,
    String? title,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      template: template ?? this.template,
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
      'Workout(id: $id, date: ${date.toHumanFriendlyFormat()}, exercises: $exercises, muscleGroups: $muscleGroups, template: $template, title: $title, notes: $notes)';
}
