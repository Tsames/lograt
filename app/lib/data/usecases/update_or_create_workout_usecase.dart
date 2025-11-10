import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class UpdateOrCreateWorkoutUsecase {
  final WorkoutRepository _repository;

  UpdateOrCreateWorkoutUsecase(this._repository);

  Future<void> call(Workout workout) async {
    await _repository.createWorkout(workout);
  }
}
