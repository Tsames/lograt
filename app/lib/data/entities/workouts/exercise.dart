import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/util/uuidv7.dart';

class Exercise {
  final String id;
  final int order;
  final List<ExerciseSet> sets;
  final ExerciseType? exerciseType;
  final String? notes;

  Exercise({
    String? id,
    int? order,
    List<ExerciseSet>? sets,
    this.exerciseType,
    this.notes,
  }) : id = id ?? uuidV7(),
       order = order ?? 0,
       sets = sets ?? const <ExerciseSet>[];

  Exercise copyWith({
    String? id,
    int? order,
    List<ExerciseSet>? sets,
    ExerciseType? exerciseType,
    String? notes,
  }) {
    return Exercise(
      id: id ?? this.id,
      order: order ?? this.order,
      sets: sets ?? this.sets,
      exerciseType: exerciseType ?? this.exerciseType,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Exercise(id: $id, order: $order, sets: $sets, exerciseType: ${exerciseType?.toString()}, notes: $notes)';
}
