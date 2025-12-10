import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

const workoutTemplatesTable = 'workout_templates';

class WorkoutTemplateFields {
  static final List<String> values = [id, date, title, description];

  static final String id = 'id';
  static final String date = 'date';
  static final String title = 'title';
  static final String description = 'description';
}

class WorkoutTemplateModel {
  final String id;
  final DateTime date;
  final String? title;
  final String? description;

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
    final id = map[WorkoutTemplateFields.id];
    if (id == null || id is! String) return null;
    final date = map[WorkoutTemplateFields.date];
    if (date == null || date is! int) return null;
    final title = map[WorkoutTemplateFields.title];
    if (title != null && title is! String) return null;
    final description = map[WorkoutTemplateFields.description];
    if (description != null && description is! String) return null;
    return WorkoutTemplateModel(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      WorkoutTemplateFields.id: id,
      WorkoutTemplateFields.date: date.millisecondsSinceEpoch,
      WorkoutTemplateFields.title: title,
      WorkoutTemplateFields.description: description,
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
