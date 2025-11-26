import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/uuidv7.dart';

const workoutTemplatesTable = 'workout_templates';

class WorkoutTemplateFields {
  static final List<String> values = [id, date, title, notes];

  static final String id = 'id';
  static final String date = 'date';
  static final String title = 'title';
  static final String notes = 'notes';
}

class WorkoutTemplateModel {
  final String id;
  final DateTime date;
  final String? title;
  final String? notes;

  const WorkoutTemplateModel({
    required this.id,
    required this.date,
    this.title,
    this.notes,
  });

  WorkoutTemplateModel.forTest({String? title, String? notes})
    : this(id: uuidV7(), date: DateTime.now(), title: title, notes: notes);

  WorkoutTemplateModel.fromEntity(WorkoutTemplate workoutTemplate)
    : this(
        id: workoutTemplate.id,
        date: workoutTemplate.date,
        title: workoutTemplate.title,
        notes: workoutTemplate.notes,
      );

  WorkoutTemplate toEntity([
    List<ExerciseTemplate> exerciseTemplates = const [],
  ]) {
    return WorkoutTemplate(
      id: id,
      date: date,
      exercises: exerciseTemplates,
      title: title,
      notes: notes,
    );
  }

  static WorkoutTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[WorkoutTemplateFields.id];
    if (id == null || id is! String) return null;
    final date = map[WorkoutTemplateFields.date];
    if (date == null || date is! int) return null;
    final title = map[WorkoutTemplateFields.title];
    if (title != null && title is! String) return null;
    final notes = map[WorkoutTemplateFields.notes];
    if (notes != null && notes is! String) return null;
    return WorkoutTemplateModel(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      WorkoutTemplateFields.id: id,
      WorkoutTemplateFields.date: date.millisecondsSinceEpoch,
      WorkoutTemplateFields.title: title,
      WorkoutTemplateFields.notes: notes,
    };
  }

  WorkoutTemplateModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? notes,
  }) {
    return WorkoutTemplateModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      notes: notes ?? this.notes,
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
      'WorkoutTemplateModel(id: $id, date: ${date.toHumanFriendlyFormat()}, title: $title, notes: $notes)';
}
