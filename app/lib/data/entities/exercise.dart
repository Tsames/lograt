import 'package:lograt/util/uuidv7.dart';

import 'exercise_set.dart';
import 'exercise_type.dart';

class Exercise {
  final String id; // UUIDv7 generated primary key
  final ExerciseType? exerciseType; // What exercise this is
  final int order; // 1st exercise, 2nd exercise, etc.
  final List<ExerciseSet> sets;
  final String? notes;

  Exercise({
    String? id,
    this.exerciseType,
    this.order = 0,
    this.sets = const <ExerciseSet>[],
    this.notes,
  }) : id = id ?? uuidV7();

  Exercise copyWith({
    String? id,
    ExerciseType? exerciseType,
    int? order,
    List<ExerciseSet>? sets,
    String? notes,
  }) {
    return Exercise(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      order: order ?? this.order,
      sets: sets ?? this.sets,
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
      'Exercise(id: $id, name: ${exerciseType?.name ?? 'null'}, order: $order, sets: $sets, notes: $notes)';
}
