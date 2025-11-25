import 'package:lograt/data/entities/exercise_type.dart';
import 'package:lograt/data/entities/templates/set_template.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseTemplate {
  final String id;
  final int order;
  final List<SetTemplate> sets;
  final ExerciseType? exerciseType;

  ExerciseTemplate({
    String? id,
    int? order,
    List<SetTemplate>? sets,
    this.exerciseType,
  }) : id = id ?? uuidV7(),
       order = order ?? 0,
       sets = sets ?? const <SetTemplate>[];

  ExerciseTemplate copyWith({
    String? id,
    int? order,
    List<SetTemplate>? sets,
    ExerciseType? exerciseType,
  }) {
    return ExerciseTemplate(
      id: id ?? this.id,
      order: order ?? this.order,
      sets: sets ?? this.sets,
      exerciseType: exerciseType ?? this.exerciseType,
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
      'ExerciseTemplate(id: $id, order: $order, sets: $sets, exerciseType: ${exerciseType?.toString()})';
}
