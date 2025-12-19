import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class CreateWorkoutUsecase {
  final WorkoutRepository _repository;

  CreateWorkoutUsecase(this._repository);

  Future<void> call(Workout workout) async {
    await _repository.insertModel<WorkoutModel>(
      WorkoutModel.fromEntity(workout),
    );
  }
}
