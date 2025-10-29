import '../entities/exercise_type.dart';
import '../repositories/workout_repository.dart';

class GetAllExerciseTypesUsecase {
  final WorkoutRepository _repository;

  GetAllExerciseTypesUsecase(this._repository);

  Future<List<ExerciseType>> call() async {
    return await _repository.getAllExerciseTypes();
  }
}
