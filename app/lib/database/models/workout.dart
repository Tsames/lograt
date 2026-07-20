import 'package:lograt/database/app_database.dart';
import 'package:lograt/database/models/exercise_instance.dart';
import 'package:lograt/database/models/workout_template.dart';
import 'package:lograt/services/uuid.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

class Workout {
  final String id;
  final DateTime date;
  final List<MuscleGroupRow> muscleGroups;
  final List<ExerciseInstance> exercises;
  final WorkoutTemplate? template;
  final String? title;
  final String? notes;

  Workout({
    String? id,
    DateTime? date,
    List<MuscleGroupRow>? muscleGroups,
    List<ExerciseInstance>? exercises,
    this.template,
    this.title,
    this.notes,
  }) : id = id ?? uuid.v7(),
       date = date ?? DateTime.now(),
       muscleGroups = muscleGroups ?? const <MuscleGroupRow>[],
       exercises = exercises ?? const <ExerciseInstance>[];

  Workout copyWith({
    String Function()? id,
    DateTime Function()? date,
    List<MuscleGroupRow> Function()? muscleGroups,
    List<ExerciseInstance> Function()? exercises,
    WorkoutTemplate? Function()? template,
    String? Function()? title,
    String? Function()? notes,
  }) {
    return Workout(
      id: id != null ? id() : this.id,
      date: date != null ? date() : this.date,
      muscleGroups: muscleGroups != null ? muscleGroups() : this.muscleGroups,
      exercises: exercises != null ? exercises() : this.exercises,
      template: template != null ? template() : this.template,
      title: title != null ? title() : this.title,
      notes: notes != null ? notes() : this.notes,
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
      'Workout(id: $id, date: ${date.toLongFriendlyFormat()}, muscleGroups: $muscleGroups, exercises: $exercises, template: $template, title: $title, notes: $notes)';
}
