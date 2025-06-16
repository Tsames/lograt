import 'package:lograt/data/database/workout_seed.dart';

import '../../domain/entities/workout.dart';
import '../../domain/repository/workout_repository.dart';
import '../database/dao/workout_dao.dart';
import '../models/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDao _workoutDao;

  WorkoutRepositoryImpl(this._workoutDao);

  @override
  Future<void> addWorkout(Workout workout) async {
    // Convert domain entity to data model before storing
    final workoutModel = WorkoutModel.fromDomain(workout);
    await _workoutDao.insertWorkout(workoutModel);
  }

  @override
  Future<void> addWorkouts(List<Workout> workouts) async {
    // Convert all domain entities to data models
    final workoutModels = workouts.map(WorkoutModel.fromDomain).toList();
    for (final workoutModel in workoutModels) {
      await _workoutDao.insertWorkout(workoutModel);
    }
  }

  @override
  Future<List<Workout>> getMostRecentWorkouts() async {
    // Get data models from DAO and convert to domain entities
    final workoutModels = await _workoutDao.getWorkouts();
    final domainWorkouts = workoutModels.map((workoutModel) => workoutModel.toDomain()).toList();

    // Sort by creation date (most recent first)
    domainWorkouts.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return domainWorkouts;
  }

  @override
  Future<void> clearWorkouts() async {
    await _workoutDao.clearTable();
  }

  @override
  Future<void> seedWorkouts() async {
    // Convert seed data to domain entities before adding
    final seedWorkouts = WorkoutSeed.sampleWorkouts.map((model) => model.toDomain()).toList();
    await addWorkouts(seedWorkouts);
  }
}
