import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class UpdateExerciseSetUsecase {
  final WorkoutRepository _repository;

  UpdateExerciseSetUsecase(this._repository);

  Future<void> updateSingleSet(ExerciseSet set, String exerciseId) async {
    return await _repository.updateModel<ExerciseSetModel>(
      ExerciseSetModel.fromEntity(entity: set, exerciseId: exerciseId),
    );
  }

  Future<void> updateMultipleSets(
    List<ExerciseSet> sets,
    String exerciseId,
  ) async {
    return await _repository.batchUpdateModels<ExerciseSetModel>(
      sets
          .map(
            (set) => ExerciseSetModel.fromEntity(
              entity: set,
              exerciseId: exerciseId,
            ),
          )
          .toList(),
    );
  }
}
