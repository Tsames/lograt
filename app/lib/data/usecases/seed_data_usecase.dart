import '../repositories/workout_repository_impl.dart';

class SeedDataUsecase {
  final WorkoutRepository _repository;

  SeedDataUsecase(this._repository);

  Future<void> call() async {
    _repository.clearWorkouts();
    _repository.seedWorkouts();
  }
}
