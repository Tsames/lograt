import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/database/dao/workout_dao.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/repository/workout_repository.dart';
import '../../domain/usecases/add_workout.dart';
import '../../domain/usecases/get_most_recent_workouts.dart';

// --- Data Layer providers ---

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.create();
});

final workoutDaoProvider = Provider<WorkoutDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return WorkoutDao(database);
});

// Repository provider - this connects your data layer to domain layer
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final dao = ref.read(workoutDaoProvider);
  return WorkoutRepositoryImpl(dao);
});

// --- Domain Layer providers ---

final getMostRecentWorkoutsProvider = Provider<GetMostRecentWorkouts>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return GetMostRecentWorkouts(repository);
});

final addWorkoutProvider = Provider<AddWorkout>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return AddWorkout(repository);
});
