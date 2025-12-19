import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class CreateExerciseUsecase {
  final WorkoutRepository _repository;

  CreateExerciseUsecase(this._repository);

  Future<void> call(Exercise exercise, String workoutId) async {
    return await _repository.insertModel<ExerciseModel>(
      ExerciseModel.fromEntity(exercise, workoutId),
    );
  }
}
