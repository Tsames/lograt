import '../../domain/repository/workout_repository.dart';
import '../../domain/entities/workout.dart';

class AddWorkout {
  final WorkoutRepository _repository;

  AddWorkout(this._repository);

  Future<void> call(Workout workout) async {
    if (workout.name.trim().isEmpty) {
      throw ArgumentError('Workout name cannot be empty');
    }

    await _repository.createWorkout(workout);
  }
}
