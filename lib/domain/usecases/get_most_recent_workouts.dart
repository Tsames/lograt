import '../../domain/repository/workout_repository.dart';
import '../../domain/entities/workout.dart';

class GetMostRecentWorkouts {
  final WorkoutRepository _repository;

  GetMostRecentWorkouts(this._repository);

  // This method encapsulates the business logic for getting recent workouts
  // It can include validation, business rules, or data transformation
  Future<List<Workout>> call() async {
    final workouts = await _repository.getMostRecentSummaries();

    // Example business rule: only return workouts from the last 30 days
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return workouts.where((workout) => workout.createdOn.isAfter(thirtyDaysAgo)).toList();
  }
}
