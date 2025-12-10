import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseTemplate {
  final String id;
  final int order;
  final List<ExerciseSetTemplate> setTemplates;
  final ExerciseType? exerciseType;

  ExerciseTemplate({
    String? id,
    int? order,
    List<ExerciseSetTemplate>? setTemplates,
    this.exerciseType,
  }) : id = id ?? uuidV7(),
       order = order ?? 0,
       setTemplates = setTemplates ?? const <ExerciseSetTemplate>[];

  ExerciseTemplate copyWith({
    String? id,
    int? order,
    List<ExerciseSetTemplate>? setTemplates,
    ExerciseType? exerciseType,
  }) {
    return ExerciseTemplate(
      id: id ?? this.id,
      order: order ?? this.order,
      setTemplates: setTemplates ?? this.setTemplates,
      exerciseType: exerciseType ?? this.exerciseType,
    );
  }

  Exercise createFromTemplate() {
    return Exercise(
      order: order,
      exerciseType: exerciseType,
      sets: setTemplates
          .map((setTemplate) => setTemplate.createFromTemplate())
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseTemplate && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseTemplate(id: $id, order: $order, setTemplates: $setTemplates, exerciseType: ${exerciseType?.toString()})';
}
