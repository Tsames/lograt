import 'package:lograt/data/database/dao/exercise_dao.dart';
import 'package:lograt/data/database/dao/exercise_set_dao.dart';
import 'package:lograt/data/database/dao/exercise_type_dao.dart';
import 'package:lograt/data/database/workout_seed.dart';
import 'package:lograt/data/models/exercise_model.dart';

import '../../domain/entities/workout.dart';
import '../../domain/repository/workout_repository.dart';
import '../database/dao/workout_dao.dart';
import '../models/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDao _workoutDao;
  final ExerciseDao _exerciseDao;
  final ExerciseTypeDao _exerciseTypeDao;
  final ExerciseSetDao _exerciseSetDao;

  WorkoutRepositoryImpl({
    required WorkoutDao workoutDao,
    required ExerciseDao exerciseDao,
    required ExerciseTypeDao exerciseTypeDao,
    required ExerciseSetDao exerciseSetDao,
  }) : _workoutDao = workoutDao,
       _exerciseDao = exerciseDao,
       _exerciseTypeDao = exerciseTypeDao,
       _exerciseSetDao = exerciseSetDao;

  @override
  Future<void> addWorkout(Workout workout) async {
    // Convert domain entity to data model before storing
    final workoutModel = WorkoutModel.fromEntity(workout);
    await _workoutDao.insertWorkout(workoutModel);
  }

  @override
  Future<void> addWorkouts(List<Workout> workouts) async {
    // Convert all domain entities to data models
    final workoutModels = workouts.map(WorkoutModel.fromEntity).toList();
    for (final workoutModel in workoutModels) {
      await _workoutDao.insertWorkout(workoutModel);
    }
  }

  @override
  Future<List<Workout>> getMostRecentWorkouts() async {
    // Get data models from DAO and convert to domain entities
    final workoutModels = await _workoutDao.getWorkouts();
    final domainWorkouts = workoutModels.map((workoutModel) => workoutModel.toEntity()).toList();

    return domainWorkouts;
  }

  @override
  Future<void> clearWorkouts() async {
    await _workoutDao.clearTable();
  }

  @override
  Future<void> seedWorkouts() async {
    // Convert seed data to domain entities before adding
    final seedWorkouts = WorkoutSeed.sampleWorkouts.map((model) => model.toEntity()).toList();
    await addWorkouts(seedWorkouts);
  }
}
