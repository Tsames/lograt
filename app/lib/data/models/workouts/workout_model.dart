import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

class WorkoutModel implements Model {
  @override
  final String id;
  final DateTime date;
  final String? title;
  final String? templateId;
  final String? notes;

  static final tableName = 'workouts';
  static final idFieldName = 'id';
  static final dateFieldName = 'date';
  static final titleFieldName = 'title';
  static final templateIdFieldName = 'template_id';
  static final notesFieldName = 'notes';

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
    List<MuscleGroup> muscleGroups = const [],
    List<Exercise> exercises = const [],
  }) {
    return Workout(
      id: id,
      date: date,
      muscleGroups: muscleGroups,
      exercises: exercises,
      title: title,
      template: template,
      notes: notes,
    );
  }

  static WorkoutModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final date = map[dateFieldName];
    if (date == null || date is! int) return null;
    final title = map[titleFieldName];
    if (title != null && title is! String) return null;
    final templateId = map[templateIdFieldName];
    if (templateId != null && templateId is! String) return null;
    final notes = map[notesFieldName];
    if (notes != null && notes is! String) return null;
    return WorkoutModel(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      templateId: templateId,
      notes: notes,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      dateFieldName: date.millisecondsSinceEpoch,
      titleFieldName: title,
      templateIdFieldName: templateId,
      notesFieldName: notes,
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
      'WorkoutModel(id: $id, date: ${date.toLongFriendlyFormat()}, title: $title, templateId: $templateId, notes: $notes)';
}
