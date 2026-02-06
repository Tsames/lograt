import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class CreateExerciseSetUsecase {
  final WorkoutRepository _repository;

  CreateExerciseSetUsecase(this._repository);

  Future<int> call(ExerciseSet set, String exerciseId) async {
    return await _repository.insertModel<ExerciseSetModel>(
      ExerciseSetModel.fromEntity(entity: set, exerciseId: exerciseId),
    );
  }
}
