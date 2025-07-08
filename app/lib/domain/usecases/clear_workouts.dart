import '../../domain/repository/workout_repository.dart';

class ClearWorkout {
  final WorkoutRepository _repository;

  ClearWorkout(this._repository);

  Future<void> call() async {
    await _repository.clearWorkouts();
  }
}
