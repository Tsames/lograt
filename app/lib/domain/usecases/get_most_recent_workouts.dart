import '../../domain/repository/workout_repository.dart';
import '../entities/workout.dart';

class GetMostRecentWorkouts {
  final WorkoutRepository _repository;

  GetMostRecentWorkouts(this._repository);

  Future<List<Workout>> call() async {
    return await _repository.getWorkoutSummaries();
  }
}
