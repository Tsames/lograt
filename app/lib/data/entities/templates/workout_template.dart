import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

class WorkoutTemplate {
  final String id;
  final DateTime date;
  final List<MuscleGroup> muscleGroups;
  final List<ExerciseTemplate> exerciseTemplates;
  final String? title;
  final String? description;

  WorkoutTemplate({
    String? id,
    DateTime? date,
    List<MuscleGroup>? muscleGroups,
    List<ExerciseTemplate>? exerciseTemplates,
    this.title,
    this.description,
  }) : id = id ?? uuidV7(),
       date = date ?? DateTime.now(),
       muscleGroups = muscleGroups ?? const <MuscleGroup>[],
       exerciseTemplates = exerciseTemplates ?? const <ExerciseTemplate>[];

  WorkoutTemplate copyWith({
    String? id,
    DateTime? date,
    List<MuscleGroup>? muscleGroups,
    List<ExerciseTemplate>? exerciseTemplates,
    String? title,
    String? description,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      date: date ?? this.date,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      exerciseTemplates: exerciseTemplates ?? this.exerciseTemplates,
      title: title ?? this.title,
      description: description ?? this.description,
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
      'WorkoutTemplate(id: $id, date: ${date.toHumanFriendlyFormat()}, exerciseTemplates: $exerciseTemplates, title: $title, description: $description)';
}
