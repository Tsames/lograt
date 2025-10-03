import '../repository/workout_repository.dart';

class SeedData {
  final WorkoutRepository _repository;

  SeedData(this._repository);

  Future<void> call() async {
    final mostRecentWorkout = await _repository.getWorkoutSummaries(1);
    if (mostRecentWorkout.isEmpty) {
      await _repository.seedWorkouts();
    }
  }
}
