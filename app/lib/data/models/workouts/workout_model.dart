import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

const workoutsTable = 'workouts';

class WorkoutFields {
  static final List<String> values = [id, date, title, templateId, notes];

  static final String id = 'id';
  static final String date = 'date';
  static final String title = 'title';
  static final String templateId = 'template_id';
  static final String notes = 'notes';
}

class WorkoutModel {
  final String id;
  final DateTime date;
  final String? title;
  final String? templateId;
  final String? notes;

  const WorkoutModel({
    required this.id,
    required this.date,
    this.title,
    this.templateId,
    this.notes,
  });

  WorkoutModel.forTest({
    DateTime? date,
    String? title,
    String? templateId,
    String? notes,
  }) : this(
         id: uuidV7(),
         date:
             date?.copyWith(millisecond: 0, microsecond: 0) ??
             DateTime.now().copyWith(millisecond: 0, microsecond: 0),
         title: title,
         templateId: templateId,
         notes: notes,
       );

  WorkoutModel.fromEntity(Workout workout)
    : this(
        id: workout.id,
        date: workout.date,
        title: workout.title,
        templateId: workout.template?.id,
        notes: workout.notes,
      );

  Workout toEntity({
    WorkoutTemplate? template,
    List<Exercise> exercises = const [],
  }) {
    return Workout(
      id: id,
      date: date,
      exercises: exercises,
      title: title,
      template: template,
      notes: notes,
    );
  }

  static WorkoutModel? fromMap(Map<String, dynamic> map) {
    final id = map[WorkoutFields.id];
    if (id == null || id is! String) return null;
    final date = map[WorkoutFields.date];
    if (date == null || date is! int) return null;
    final title = map[WorkoutFields.title];
    if (title != null && title is! String) return null;
    final templateId = map[WorkoutFields.templateId];
    if (templateId != null && templateId is! String) return null;
    final notes = map[WorkoutFields.notes];
    if (notes != null && notes is! String) return null;
    return WorkoutModel(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      templateId: templateId,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      WorkoutFields.id: id,
      WorkoutFields.date: date.millisecondsSinceEpoch,
      WorkoutFields.title: title,
      WorkoutFields.templateId: templateId,
      WorkoutFields.notes: notes,
    };
  }

  WorkoutModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? templateId,
    String? notes,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WorkoutModel(id: $id, date: ${date.toHumanFriendlyFormat()}, title: $title, templateId: $templateId, notes: $notes)';
}
