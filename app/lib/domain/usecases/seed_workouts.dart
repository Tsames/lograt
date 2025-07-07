import '../../domain/repository/workout_repository.dart';

class SeedWorkouts {
  final WorkoutRepository _repository;

  SeedWorkouts(this._repository);

  Future<void> call() async {
    await _repository.seedWorkouts();
  }
}
