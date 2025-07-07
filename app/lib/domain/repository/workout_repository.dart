import 'package:lograt/domain/entities/exercise_type.dart';

import '../../domain/entities/workout.dart';
import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/workout_summary.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSummary>> getMostRecentSummaries(int limit);
  Future<Workout> getFullWorkoutDetails(int workoutId);
  Future<List<Exercise>> getExercisesOfType({required int typeId, int limit});

  Future<int> createWorkout(Workout workout);
  Future<void> createWorkouts(List<Workout> workouts);
  Future<int> createExercise({required Exercise exercise, required int workoutId});
  Future<int> createExerciseType(ExerciseType type);
  Future<int> createExerciseSet({required ExerciseSet set, required int exerciseId});

  Future<void> updateWorkout(Workout entity);
  Future<void> updateExercise({required Exercise entity, required int workoutId});
  Future<void> updateExerciseType(ExerciseType entity);
  Future<void> updateExerciseSet({required ExerciseSet entity, required int exerciseId});

  Future<int> deleteWorkout(int id);
  Future<int> deleteExercise(int id);
  Future<int> deleteExerciseType(int id);
  Future<int> deleteExerciseSet(int id);

  Future<void> clearWorkouts();
  Future<void> seedWorkouts();
}
