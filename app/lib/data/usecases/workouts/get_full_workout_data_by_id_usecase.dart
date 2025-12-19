import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class GetFullWorkoutDataByIdUsecase {
  final WorkoutRepository _repository;

  GetFullWorkoutDataByIdUsecase(this._repository);

  Future<Workout> call(String id) async {
    return await _repository.getFullWorkoutDetails(id);
  }
}
