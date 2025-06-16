import 'package:lograt/data/database/workout_seed.dart';

import '../database/dao/workout_dao.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final WorkoutDao _workoutDao;

  WorkoutRepository(this._workoutDao);

  Future<void> addWorkout(Workout workout) async {
    _workoutDao.insertWorkout(workout);
  }

  Future<void> addWorkouts(List<Workout> workouts) async {
    for (final workout in workouts) {
      _workoutDao.insertWorkout(workout);
    }
  }

  Future<List<Workout>> getMostRecentWorkouts() async {
    final workouts = await _workoutDao.getWorkouts();
    return workouts..sort((a, b) => b.createdOn.compareTo(a.createdOn));
  }

  Future<void> clearWorkouts() async {
    _workoutDao.clearTable();
  }

  Future<void> seedWorkouts() async {
    addWorkouts(WorkoutSeed.sampleWorkouts);
  }
}
