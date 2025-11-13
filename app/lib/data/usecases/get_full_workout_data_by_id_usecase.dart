import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetFullWorkoutDataByIdUsecase {
  final WorkoutRepository _repository;

  GetFullWorkoutDataByIdUsecase(this._repository);

  Future<Workout> call(String id) async {
    return await _repository.getFullWorkoutDetails(id);
  }
}
