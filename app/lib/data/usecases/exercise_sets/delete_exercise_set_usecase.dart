import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class DeleteExerciseSetUsecase {
  final WorkoutRepository _repository;

  DeleteExerciseSetUsecase(this._repository);

  Future<void> call(String setId) async {
    await _repository.deleteModel<ExerciseSetModel>(setId);
  }
}
