import '../../util/paginated_results.dart';
import '../entities/exercise_type.dart';
import '../repositories/workout_repository_impl.dart';

class GetPaginatedExerciseTypesUsecase {
  static const pageSize = 50;
  final WorkoutRepository _repository;

  GetPaginatedExerciseTypesUsecase(this._repository);

  Future<PaginatedResults<List<ExerciseType>>> call(int? offset) async {
    final paginatedExerciseTypes = await _repository.getExerciseTypes(
      limit: pageSize,
      offset: offset,
    );
    return PaginatedResults<List<ExerciseType>>(
      paginatedExerciseTypes,
      (offset ?? 0) + pageSize,
      paginatedExerciseTypes.length == pageSize,
    );
  }
}
