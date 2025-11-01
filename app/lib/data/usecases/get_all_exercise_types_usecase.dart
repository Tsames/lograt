import '../entities/exercise_type.dart';
import '../repositories/workout_repository.dart';

class GetExerciseTypesUsecase {
  final WorkoutRepository _repository;

  GetExerciseTypesUsecase(this._repository);

  Future<List<ExerciseType>> call() async {
    return await _repository.getAllExerciseTypes();
  }
}
