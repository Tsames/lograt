import '../entities/exercise_type.dart';
import '../repositories/workout_repository.dart';

class GetAllExerciseTypesUsecaseUsecase {
  final WorkoutRepository _repository;

  GetAllExerciseTypesUsecaseUsecase(this._repository);

  Future<List<ExerciseType>> call() async {
    return await _repository.getAllExerciseTypes();
  }
}
