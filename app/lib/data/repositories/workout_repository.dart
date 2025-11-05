import 'package:sqflite/sqflite.dart';

import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/exercise_type.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<Workout?> getWorkoutSummary(int workoutId);

  Future<List<Workout>> getWorkoutSummaries({int limit, int? offset});

  Future<List<Workout>> getWorkoutSummariesAfterTime(
    int dateTimeThresholdInMilliseconds,
  );

  Future<Workout> getFullWorkoutDetails(int workoutId);

  Future<List<Exercise>> getExercisesOfType({required int typeId, int limit});

  Future<List<ExerciseType>> getExerciseTypes({
    int? limit,
    int? offset,
    Transaction? txn,
  });

  Future<int> createWorkout(Workout workout);

  Future<void> createWorkouts(List<Workout> workouts);

  Future<int> createExercise({
    required Exercise exercise,
    required int workoutId,
  });

  Future<int> createExerciseType(ExerciseType type);

  Future<int> createExerciseSet({
    required ExerciseSet set,
    required int exerciseId,
  });

  Future<void> updateWorkout(Workout entity);

  Future<void> updateExercise({
    required Exercise entity,
    required int workoutId,
  });

  Future<void> updateExerciseType(ExerciseType entity);

  Future<void> updateExerciseSet({
    required ExerciseSet entity,
    required int exerciseId,
  });

  Future<int> deleteWorkout(int id);

  Future<int> deleteExercise(int id);

  Future<bool> deleteExerciseType(int id);

  Future<int> deleteExerciseSet(int id);

  Future<void> clearWorkouts();

  Future<void> seedWorkouts();
}
