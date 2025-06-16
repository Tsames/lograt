import '../../data/models/workout.dart';

abstract class WorkoutRepository {
  Future<void> addWorkout(Workout workout);
  Future<void> addWorkouts(List<Workout> workouts);
  Future<List<Workout>> getMostRecentWorkouts();
  Future<void> clearWorkouts();
  Future<void> seedWorkouts();
}
