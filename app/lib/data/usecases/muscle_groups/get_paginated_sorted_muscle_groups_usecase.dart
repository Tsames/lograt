import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/util/paginated_results.dart';

class GetPaginatedSortedMuscleGroupsUsecase {
  final int pageSize;
  final WorkoutRepository _repository;

  GetPaginatedSortedMuscleGroupsUsecase(this._repository, {this.pageSize = 50});

  Future<PaginatedResults<List<MuscleGroup>>> call(int? offset) async {
    final muscleGroupToReturn = await _repository
        .getPaginatedSortedMuscleGroups(limit: pageSize, offset: offset);
    return PaginatedResults<List<MuscleGroup>>(
      muscleGroupToReturn,
      (offset ?? 0) + pageSize,
      muscleGroupToReturn.length == pageSize,
    );
  }
}
