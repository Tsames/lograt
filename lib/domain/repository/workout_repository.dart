import 'package:lograt/domain/entities/exercise_type.dart';

import '../../domain/entities/workout.dart';
import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/workout_summary.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSummary>> getMostRecentSummaries(int limit);
  Future<Workout> getFullWorkoutDetails(int workoutId);
  Future<List<Exercise>> getRecentExercisesOfType({ExerciseType type, int limit});

  Future<int> createWorkout(Workout workout);
  Future<int> createExercise({required Exercise exercise, required int workoutId});
  Future<int> createExerciseType(ExerciseType type);
  Future<int> createExerciseSet({required ExerciseSet set, required int exerciseId});
  Future<int> createWorkouts(List<Workout> workouts);

  Future<void> updateWorkout({required int workoutId, required Workout updatedWorkout});
  Future<void> updateExercise({required int exerciseId, required Exercise updatedExercise});
  Future<void> updateExerciseType({required int typeId, required ExerciseType updatedType});
  Future<void> updateExerciseSet({required int setId, required ExerciseSet updatedSet});

  Future<void> deleteWorkout(int workoutId);
  Future<void> deleteExercise(int exerciseId);
  Future<void> deleteExerciseType(int typeId);
  Future<void> deleteExerciseSet(int setId);

  Future<void> clearWorkouts();
  Future<void> seedWorkouts();
}
