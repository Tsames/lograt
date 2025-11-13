abstract class WorkoutException implements Exception {
  final String message;
  final String? workoutId;

  const WorkoutException(this.message, [this.workoutId]);

  @override
  String toString() => 'WorkoutException: $message';
}

/// Thrown when trying to access a workout that doesn't exist
class WorkoutNotFoundException extends WorkoutException {
  WorkoutNotFoundException(String workoutId)
    : super('Workout with ID $workoutId was not found', workoutId);

  @override
  String toString() =>
      'WorkoutNotFoundException: Workout with ID $workoutId was not found';
}

/// Throw when there are problems with the workout data integrity
class WorkoutDataException extends WorkoutException {
  WorkoutDataException(super.message, [super.workoutId]);

  @override
  String toString() => 'WorkoutDataException: $message';
}
