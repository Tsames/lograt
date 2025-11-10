import '../entities/workout.dart';
import '../repositories/workout_repository_impl.dart';

class AddWorkoutUsecase {
  final WorkoutRepository _repository;

  AddWorkoutUsecase(this._repository);

  Future<void> call(Workout workout) async {
    if (workout.name.trim().isEmpty) {
      throw ArgumentError('Workout name cannot be empty');
    }

    await _repository.createWorkout(workout);
  }
}
