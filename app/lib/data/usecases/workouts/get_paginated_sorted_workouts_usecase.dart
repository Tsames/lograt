import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/util/paginated_results.dart';

class GetPaginatedSortedWorkoutsUsecase {
  final int pageSize;
  final WorkoutRepository _repository;

  GetPaginatedSortedWorkoutsUsecase(this._repository, {this.pageSize = 25});

  Future<PaginatedResults<List<Workout>>> call(int? offset) async {
    final workoutsToReturn = await _repository
        .getPaginatedSortedWorkoutSummaries(limit: pageSize, offset: offset);
    return PaginatedResults<List<Workout>>(
      workoutsToReturn,
      (offset ?? 0) + pageSize,
      workoutsToReturn.length == pageSize,
    );
  }
}
