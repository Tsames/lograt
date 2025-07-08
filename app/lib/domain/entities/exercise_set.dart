/// Represents a single set within an exercise
class ExerciseSet {
  final int? id; // SQLite generated primary key
  final int order; // 1st set, 2nd set, etc. within this exercise
  final int reps;
  final int? weightPounds; // Weight used (null for body weight exercises)
  final Duration?
  restTimeSeconds; // Rest time before this set, for the first set this will be null
  final SetType setType; // Regular, warm-up, drop set, etc.

  int get volume {
    return reps * (weightPounds ?? 1);
  }

  const ExerciseSet({
    required this.id,
    required this.order,
    required this.reps,
    this.weightPounds,
    this.restTimeSeconds,
    this.setType = SetType.working,
  });

  ExerciseSet copyWith({
    int? id,
    String? workoutExerciseId,
    int? order,
    int? reps,
    int? weightPounds,
    Duration? duration,
    double? distance,
    Duration? restTimeSeconds,
    DateTime? completedAt,
    String? notes,
    SetType? setType,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      order: order ?? this.order,
      reps: reps ?? this.reps,
      weightPounds: weightPounds ?? this.weightPounds,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      setType: setType ?? this.setType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSet &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseSet{ id: ${id ?? 'null'}, order: $order, weight: ${weightPounds ?? 'BW'}, reps: $reps }';
}

enum SetType {
  warmup('Warm-up'),
  working('Working Set'), // Main work sets at target weight
  dropSet('Drop Set'), // Reduce weight mid-set
  failure('To Failure'); // Performed until failure

  const SetType(this.displayName);
  final String displayName;
}
