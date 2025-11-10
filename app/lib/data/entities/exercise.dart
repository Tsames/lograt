import 'package:lograt/data/entities/set_type.dart';

import 'exercise_set.dart';
import 'exercise_type.dart';

/// Represents a specific exercise performed within a workout
class Exercise {
  final int? id; // SQLite generated primary key
  final ExerciseType exerciseType; // What exercise this is
  final int order; // 1st exercise, 2nd exercise, etc.
  final List<ExerciseSet> sets;
  final String? notes;

  const Exercise({
    this.id,
    required this.exerciseType,
    required this.order,
    required this.sets,
    this.notes,
  });

  int get totalReps {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  Exercise copyWith({
    int? id,
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

  Exercise copyWithNewSet() {
    if (sets.isEmpty) {
      return copyWith(sets: [ExerciseSet(order: 0, setType: SetType.warmup)]);
    }
    final lastSet = sets.last;
    return copyWith(
      sets: [
        ...sets,
        ExerciseSet(
          order: lastSet.order + 1,
          setType: lastSet.setType,
          units: lastSet.units,
        ),
      ],
    );
  }

  Exercise copyWithLastSetRemoved() {
    if (sets.isEmpty) return this;
    return copyWith(sets: sets.sublist(0, sets.length - 1));
  }

  Exercise copyWithLastSetDuplicated() {
    if (sets.isEmpty) return this;
    final lastSet = sets.last;
    return copyWith(
      sets: [
        ...sets,
        ExerciseSet(
          order: lastSet.order + 1,
          setType: lastSet.setType,
          weight: lastSet.weight,
          units: lastSet.units,
          reps: lastSet.reps,
          restTime: lastSet.restTime,
        ),
      ],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Exercise{ id: ${id ?? 'null'}, name: ${exerciseType.name}, sets: ${sets.length} }';
}
