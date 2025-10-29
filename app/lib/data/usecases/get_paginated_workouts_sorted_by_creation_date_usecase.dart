import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetPaginatedWorkoutsSortedByCreationDateUsecase {
  static const pageSize = 25;
  final WorkoutRepository _repository;

  GetPaginatedWorkoutsSortedByCreationDateUsecase(this._repository);

  Future<PaginatedWorkoutResults> call(int? offset) async {
    final workoutsToReturn = await _repository.getWorkoutSummaries(
      limit: pageSize,
      offset: offset,
    );
    return PaginatedWorkoutResults(
      workoutsToReturn,
      (offset ?? 0) + pageSize,
      workoutsToReturn.length == pageSize,
    );
  }
}

class PaginatedWorkoutResults {
  final List<Workout> workouts;
  final int nextOffset;
  final bool hasMore;

  const PaginatedWorkoutResults(this.workouts, this.nextOffset, this.hasMore);
}
