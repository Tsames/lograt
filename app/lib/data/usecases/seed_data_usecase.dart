import 'package:lograt/data/database/seed_data.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class SeedDataUsecase {
  final WorkoutRepository _repository;

  SeedDataUsecase(this._repository);

  Future<void> call() async {
    await _repository.seedWorkoutData(SeedData.sampleWorkouts);
  }
}
