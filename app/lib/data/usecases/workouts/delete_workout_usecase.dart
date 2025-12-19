import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class DeleteWorkoutUsecase {
  final WorkoutRepository _repository;

  DeleteWorkoutUsecase(this._repository);

  Future<void> call(String workoutId) async {
    await _repository.deleteModel<WorkoutModel>(workoutId);
  }
}
