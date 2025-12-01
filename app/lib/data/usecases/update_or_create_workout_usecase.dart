import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';

class UpdateOrCreateWorkoutDataUsecase {
  final WorkoutRepository _repository;

  UpdateOrCreateWorkoutDataUsecase(this._repository);

  Future<void> createWorkout(Workout workout) async {
    await _repository.createWorkout(workout);
  }

  Future<void> updateExercise(Exercise exercise, String workoutId) async {
    await _repository.updateExercise(entity: exercise, workoutId: workoutId);
  }

  /// Creates an [ExerciseSet] in persistent storage and returns its id
  Future<int> createSet(ExerciseSet set, String exerciseId) async {
    return await _repository.createExerciseSet(
      set: set,
      exerciseId: exerciseId,
    );
  }

  /// Updates an existing [ExerciseSet] in persistent storage
  Future<void> updateSet(ExerciseSet set, String exerciseId) async {
    return await _repository.updateExerciseSet(
      entity: set,
      exerciseId: exerciseId,
    );
  }

  Future<void> removeSet(ExerciseSet set, String exerciseId) async {
    await _repository.deleteExerciseSet(set.id);
  }
}
