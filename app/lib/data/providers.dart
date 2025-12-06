import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_exercise_type_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_template_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/templates/exercise_set_template_dao.dart';
import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/dao/workout/exercise_dao.dart';
import 'package:lograt/data/dao/workout/exercise_set_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/data/usecases/get_full_workout_data_by_id_usecase.dart';
import 'package:lograt/data/usecases/get_paginated_exercise_types_usecase.dart';
import 'package:lograt/data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';
import 'package:lograt/data/usecases/seed_data_usecase.dart';
import 'package:lograt/data/usecases/update_or_create_workout_usecase.dart';

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

final workoutTemplateDaoProvider = Provider<WorkoutTemplateDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return WorkoutTemplateDao(database);
});

final exerciseTemplateDaoProvider = Provider<ExerciseTemplateDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ExerciseTemplateDao(database);
});

final exerciseSetTemplateDaoProvider = Provider<ExerciseSetTemplateDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ExerciseSetTemplateDao(database);
});

final muscleGroupDaoProvider = Provider<MuscleGroupDao>((ref) {
  final database = ref.read(appDatabaseProvider);
  return MuscleGroupDao(database);
});

final muscleGroupToWorkoutDaoProvider = Provider<MuscleGroupToWorkoutDao>((
  ref,
) {
  final database = ref.read(appDatabaseProvider);
  return MuscleGroupToWorkoutDao(database);
});

final muscleGroupToWorkoutTemplateDaoProvider =
    Provider<MuscleGroupToWorkoutTemplateDao>((ref) {
      final database = ref.read(appDatabaseProvider);
      return MuscleGroupToWorkoutTemplateDao(database);
    });

final muscleGroupToExerciseTypeDaoProvider =
    Provider<MuscleGroupToExerciseTypeDao>((ref) {
      final database = ref.read(appDatabaseProvider);
      return MuscleGroupToExerciseTypeDao(database);
    });

// --- Repository provider ---

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final database = ref.read(appDatabaseProvider);

  final workoutDao = ref.read(workoutDaoProvider);
  final exerciseDao = ref.read(exerciseDaoProvider);
  final exerciseTypeDao = ref.read(exerciseTypeDaoProvider);
  final exerciseSetDao = ref.read(exerciseSetDaoProvider);

  final workoutTemplateDao = ref.read(workoutTemplateDaoProvider);
  final exerciseTemplateDao = ref.read(exerciseTemplateDaoProvider);
  final exerciseSetTemplateDao = ref.read(exerciseSetTemplateDaoProvider);

  final muscleGroupDao = ref.read(muscleGroupDaoProvider);
  final muscleGroupToWorkoutDao = ref.read(muscleGroupToWorkoutDaoProvider);
  final muscleGroupToWorkoutTemplateDao = ref.read(
    muscleGroupToWorkoutTemplateDaoProvider,
  );
  final muscleGroupToExerciseTypeDao = ref.read(
    muscleGroupToExerciseTypeDaoProvider,
  );

  return WorkoutRepository(
    databaseConnection: database,
    workoutDao: workoutDao,
    exerciseDao: exerciseDao,
    exerciseTypeDao: exerciseTypeDao,
    exerciseSetDao: exerciseSetDao,
    workoutTemplateDao: workoutTemplateDao,
    exerciseTemplateDao: exerciseTemplateDao,
    exerciseSetTemplateDao: exerciseSetTemplateDao,
    muscleGroupDao: muscleGroupDao,
    muscleGroupToWorkoutDao: muscleGroupToWorkoutDao,
    muscleGroupToWorkoutTemplateDao: muscleGroupToWorkoutTemplateDao,
    muscleGroupToExerciseTypeDao: muscleGroupToExerciseTypeDao,
  );
});

// --- Usecase providers ---

final getSortedPaginatedWorkoutsUsecaseProvider =
    Provider<GetPaginatedWorkoutsSortedByCreationDateUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return GetPaginatedWorkoutsSortedByCreationDateUsecase(repository);
    });

final getFullWorkoutDataByIdUsecaseProvider =
    Provider<GetFullWorkoutDataByIdUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return GetFullWorkoutDataByIdUsecase(repository);
    });

final getExerciseTypesUsecaseProvider =
    Provider<GetPaginatedExerciseTypesUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return GetPaginatedExerciseTypesUsecase(repository);
    });

final updateOrCreateWorkoutUsecaseProvider =
    Provider<UpdateOrCreateWorkoutDataUsecase>((ref) {
      final repository = ref.read(workoutRepositoryProvider);
      return UpdateOrCreateWorkoutDataUsecase(repository);
    });

final seedDataUsecaseProvider = Provider<SeedDataUsecase>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return SeedDataUsecase(repository);
});
