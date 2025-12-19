import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class UpdateExerciseUsecase {
  final WorkoutRepository _repository;

  UpdateExerciseUsecase(this._repository);

  Future<void> updateSingleExercise(Exercise exercise, String workoutId) async {
    return await _repository.updateModel<ExerciseModel>(
      ExerciseModel.fromEntity(exercise, workoutId),
    );
  }

  Future<void> updateMultipleExercises(
    List<Exercise> exercises,
    String workoutId,
  ) async {
    return await _repository.batchUpdateModels<ExerciseModel>(
      exercises.map((set) => ExerciseModel.fromEntity(set, workoutId)).toList(),
    );
  }
}
