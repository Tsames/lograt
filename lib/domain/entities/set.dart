/// Represents a single set within an exercise
class Set {
  final String id;
  final int setNumber; // 1st set, 2nd set, etc. within this exercise
  final int reps; // Number of repetitions performed
  final int? weight; // Weight used (null for bodyweight exercises)
  final Duration? restTime; // Rest time before this set, for the first set this will be null
  final SetType setType; // Regular, warm-up, drop set, etc.

  /// Volume is the weight * reps, or just the reps if using body weight
  int get volume {
    return reps * (weight ?? 1);
  }

  const Set({
    required this.id,
    required this.setNumber,
    required this.reps,
    this.weight,
    this.restTime,
    this.setType = SetType.working,
  });

  Set copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    int? reps,
    int? weight,
    Duration? duration,
    double? distance,
    Duration? restTime,
    DateTime? completedAt,
    String? notes,
    SetType? setType,
  }) {
    return Set(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restTime: restTime ?? this.restTime,
      setType: setType ?? this.setType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Set && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Set(weight: ${weight ?? 'BW'}, reps: $reps)';
}

enum SetType {
  warmup('Warm-up'),
  working('Working Set'), // Main work sets at target weight
  dropSet('Drop Set'), // Reduce weight mid-set
  failure('To Failure'); // Performed until failure

  const SetType(this.displayName);
  final String displayName;
}
