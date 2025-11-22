import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/util/paginated_results.dart';

class GetPaginatedWorkoutsSortedByCreationDateUsecase {
  static const pageSize = 25;
  final WorkoutRepository _repository;

  GetPaginatedWorkoutsSortedByCreationDateUsecase(this._repository);

  Future<PaginatedResults<List<Workout>>> call(int? offset) async {
    final workoutsToReturn = await _repository.getWorkoutSummaries(
      limit: pageSize,
      offset: offset,
    );
    return PaginatedResults<List<Workout>>(
      workoutsToReturn,
      (offset ?? 0) + pageSize,
      workoutsToReturn.length == pageSize,
    );
  }
}
