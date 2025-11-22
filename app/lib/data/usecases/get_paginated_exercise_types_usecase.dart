import 'package:lograt/data/entities/exercise_type.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/util/paginated_results.dart';

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
