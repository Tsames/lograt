import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/data/repositories/workout_repository_impl.dart';
import 'package:lograt/data/usecases/add_workout_usecase.dart';
import 'package:lograt/data/usecases/get_all_exercise_types_usecase.dart';
import 'package:lograt/data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';
import 'package:lograt/data/usecases/get_this_weeks_workouts_usecase.dart';
import 'package:lograt/data/usecases/seed_data_usecase.dart';

import 'dao/exercise_dao.dart';
import 'dao/exercise_set_dao.dart';
import 'dao/exercise_type_dao.dart';
import 'dao/workout_dao.dart';
import 'database/app_database.dart';

// --- Database provider ---

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.create();
});

// --- DAO providers ---

final workoutDaoProvider = Provider<WorkoutDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return WorkoutDao(database);
});

final exerciseTypeDaoProvider = Provider<ExerciseTypeDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ExerciseTypeDao(database);
});

final exerciseDaoProvider = Provider<ExerciseDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ExerciseDao(database);
});

final exerciseSetDaoProvider = Provider<ExerciseSetDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ExerciseSetDao(database);
});

// --- Repository provider ---

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final database = ref.read(appDatabaseProvider);
  final workoutDao = ref.read(workoutDaoProvider);
  final exerciseDao = ref.read(exerciseDaoProvider);
  final exerciseTypeDao = ref.read(exerciseTypeDaoProvider);
  final exerciseSetDao = ref.read(exerciseSetDaoProvider);

  return WorkoutRepositoryImpl(
    databaseConnection: database,
    workoutDao: workoutDao,
    exerciseDao: exerciseDao,
    exerciseTypeDao: exerciseTypeDao,
    exerciseSetDao: exerciseSetDao,
  );
});

// --- Usecase providers ---

final getSortedPaginatedWorkoutsUsecaseProvider =
    Provider<GetPaginatedWorkoutsSortedByCreationDateUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return GetPaginatedWorkoutsSortedByCreationDateUsecase(repository);
    });

final getThisWeeksWorkoutsUsecaseProvider =
    Provider<GetThisWeeksWorkoutsUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return GetThisWeeksWorkoutsUsecase(repository);
    });

final getAllExerciseTypesUsecaseProvider = Provider<GetAllExerciseTypesUsecase>(
  (ref) {
    final repository = ref.read(workoutRepositoryProvider);
    return GetAllExerciseTypesUsecase(repository);
  },
);

final addWorkoutUsecaseProvider = Provider<AddWorkoutUsecase>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return AddWorkoutUsecase(repository);
});

final seedDataUsecaseProvider = Provider<SeedDataUsecase>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return SeedDataUsecase(repository);
});
