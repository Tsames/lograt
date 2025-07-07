import '../../domain/repository/workout_repository.dart';
import '../../domain/entities/workout.dart';

class ClearWorkout {
  final WorkoutRepository _repository;

  ClearWorkout(this._repository);

  Future<void> call() async {
    await _repository.clearWorkouts();
  }
}
