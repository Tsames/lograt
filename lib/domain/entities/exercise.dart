import 'package:lograt/domain/entities/workout_type.dart';

import 'set.dart';

/// Represents a specific exercise performed within a workout
class Exercise {
  final String id;
  final ExerciseType exerciseType; // What exercise this is
  final int order; // 1st exercise, 2nd exercise, etc.
  final List<Set> sets; // The actual performance data
  final String? notes; // Optional notes for this specific exercise instance

  const Exercise({required this.id, required this.exerciseType, required this.order, required this.sets, this.notes});

  /// Total volume for this exercise (sum of all sets' volume)
  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + set.volume);
  }

  /// Total reps across all sets
  int get totalReps {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  Exercise copyWith({String? id, ExerciseType? exerciseType, int? orderInWorkout, List<Set>? sets, String? notes}) {
    return Exercise(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      order: orderInWorkout ?? this.order,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Exercise(name: ${exerciseType.name}, sets: ${sets.length})';
}
