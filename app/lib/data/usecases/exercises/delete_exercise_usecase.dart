import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class DeleteExerciseUsecase {
  final WorkoutRepository _repository;

  DeleteExerciseUsecase(this._repository);

  Future<void> call(String exerciseId) async {
    await _repository.deleteModel<ExerciseModel>(exerciseId);
  }
}
