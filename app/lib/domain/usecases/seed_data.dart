import '../repository/workout_repository.dart';

class SeedData {
  final WorkoutRepository _repository;

  SeedData(this._repository);

  Future<void> call() async {
    _repository.clearWorkouts();
    _repository.seedWorkouts();
  }
}
