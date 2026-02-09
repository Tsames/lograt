import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

class WorkoutTemplateModel implements Model {
  @override
  final String id;
  final DateTime date;
  final String? title;
  final String? description;

  static final tableName = 'workout_templates';
  static final idFieldName = 'id';
  static final dateFieldName = 'date';
  static final titleFieldName = 'title';
  static final descriptionFieldName = 'description';

  const WorkoutTemplateModel({
    required this.id,
    required this.date,
    this.title,
    this.description,
  });

  WorkoutTemplateModel.forTest({
    DateTime? date,
    String? title,
    String? description,
  }) : this(
         id: uuidV7(),
         date:
             date?.copyWith(millisecond: 0, microsecond: 0) ??
             DateTime.now().copyWith(millisecond: 0, microsecond: 0),
         title: title,
         description: description,
       );

  WorkoutTemplateModel.fromEntity(WorkoutTemplate workoutTemplate)
    : this(
        id: workoutTemplate.id,
        date: workoutTemplate.date,
        title: workoutTemplate.title,
        description: workoutTemplate.description,
      );

  WorkoutTemplate toEntity([
    List<ExerciseTemplate> exerciseTemplates = const [],
  ]) {
    return WorkoutTemplate(
      id: id,
      date: date,
      exerciseTemplates: exerciseTemplates,
      title: title,
      description: description,
    );
  }

  static WorkoutTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final date = map[dateFieldName];
    if (date == null || date is! int) return null;
    final title = map[titleFieldName];
    if (title != null && title is! String) return null;
    final description = map[descriptionFieldName];
    if (description != null && description is! String) return null;
    return WorkoutTemplateModel(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      description: description,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      dateFieldName: date.millisecondsSinceEpoch,
      titleFieldName: title,
      descriptionFieldName: description,
    };
  }

  WorkoutTemplateModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? description,
  }) {
    return WorkoutTemplateModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutTemplateModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WorkoutTemplateModel(id: $id, date: ${date.toLongFriendlyFormat()}, title: $title, description: $description)';
}
