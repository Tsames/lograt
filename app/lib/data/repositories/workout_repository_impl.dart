import 'package:flutter/foundation.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/exercise_dao.dart';
import '../dao/exercise_set_dao.dart';
import '../dao/exercise_type_dao.dart';
import '../dao/workout_dao.dart';
import '../database/seed_data.dart';
import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/exercise_type.dart';
import '../entities/workout.dart';
import '../exceptions/workout_exceptions.dart';
import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/exercise_type_model.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final AppDatabase _db;
  final WorkoutDao _workoutDao;
  final ExerciseDao _exerciseDao;
  final ExerciseTypeDao _exerciseTypeDao;
  final ExerciseSetDao _exerciseSetDao;

  WorkoutRepository({
    required AppDatabase databaseConnection,
    required WorkoutDao workoutDao,
    required ExerciseDao exerciseDao,
    required ExerciseTypeDao exerciseTypeDao,
    required ExerciseSetDao exerciseSetDao,
  }) : _db = databaseConnection,
       _workoutDao = workoutDao,
       _exerciseDao = exerciseDao,
       _exerciseTypeDao = exerciseTypeDao,
       _exerciseSetDao = exerciseSetDao;

  /// Get a [Workout] without its corresponding exercises.
  /// Returns null if the workout does not exist in the database.
  Future<Workout?> getWorkoutSummary(int workoutId) async {
    try {
      final workoutModel = await _workoutDao.getById(workoutId);

      return workoutModel?.toEntity();
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to load recent workout summaries: $e');
    } catch (e) {
      throw WorkoutDataException(
        'Unexpected error loading recent workout summaries: $e',
      );
    }
  }

  /// Get a list of all of [Workout]s with creation dates after the given [dateTimeThresholdInMilliseconds]
  /// ordered by creation date descending.
  Future<List<Workout>> getWorkoutSummariesAfterTime(
    int dateTimeThresholdInMilliseconds,
  ) async {
    try {
      final workoutModels = await _workoutDao.getWorkoutSummariesAfterTime(
        dateTimeThresholdInMilliseconds,
      );

      final workoutEntities = workoutModels
          .map((workoutModel) => workoutModel.toEntity())
          .toList();

      return workoutEntities;
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to load recent workout summaries: $e');
    } catch (e) {
      throw WorkoutDataException(
        'Unexpected error loading recent workout summaries: $e',
      );
    }
  }

  /// Get a list of length [limit] of [Workout]s without their corresponding exercises
  /// ordered by creation date descending.
  Future<List<Workout>> getWorkoutSummaries({int? limit, int? offset}) async {
    try {
      final workoutModels = await _workoutDao.getWorkoutSummaries(
        limit: limit,
        offset: offset,
      );

      final workoutEntities = workoutModels
          .map((workoutModel) => workoutModel.toEntity())
          .toList();

      return workoutEntities;
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to load recent workout summaries: $e');
    } catch (e) {
      throw WorkoutDataException(
        'Unexpected error loading recent workout summaries: $e',
      );
    }
  }

  /// Get a [Workout] including all its associated exercises and their associated sets by [workoutId].
  /// Main method for retrieving data necessary for the workout details and log page.
  Future<Workout> getFullWorkoutDetails(int workoutId) async {
    try {
      // Get the workout in question
      final workoutModel = await _workoutDao.getById(workoutId);
      if (workoutModel == null) {
        throw WorkoutNotFoundException(workoutId);
      }

      if (kDebugMode) {
        debugPrint("Found workout: ${workoutModel.toString()}");
      }

      // Get all exercises for the workout
      final exerciseModels = await _exerciseDao.getByWorkoutId(workoutId);
      if (kDebugMode) {
        debugPrint("Found exercises: $exerciseModels");
      }
      if (exerciseModels.isEmpty) {
        return workoutModel.toEntity();
      }

      final exerciseEntityFutures = exerciseModels.map((exerciseModel) async {
        if (kDebugMode) {
          debugPrint("Iterating for exercise: $exerciseModel");
        }
        return await _buildExerciseEntity(exerciseModel);
      }).toList();

      final exerciseEntities = await Future.wait(exerciseEntityFutures);

      final validExercises = exerciseEntities.whereType<Exercise>().toList();

      return workoutModel.toEntity(validExercises);
    } on WorkoutNotFoundException {
      rethrow;
    } on DatabaseException catch (e) {
      throw WorkoutDataException(
        'Failed to load workout details for workout $workoutId: $e',
      );
    } catch (e) {
      throw WorkoutDataException(
        'Unexpected error loading workout $workoutId: $e',
      );
    }
  }

  /// Helper method to [getFullWorkoutDetails] that builds an [Exercise] with all its associated sets from an [ExerciseModel].
  /// Returns null if an error is encountered or no [ExerciseType] can be found in the database.
  Future<Exercise?> _buildExerciseEntity(ExerciseModel exerciseModel) async {
    try {
      if (exerciseModel.exerciseTypeId == null) {
        return null;
      }
      final exerciseTypeModel = await _exerciseTypeDao.getById(
        exerciseModel.exerciseTypeId!,
      );
      if (kDebugMode) {
        debugPrint("\tExercise Type found: $exerciseTypeModel");
      }
      if (exerciseTypeModel == null) {
        return null;
      }

      final exerciseSetModels = await _exerciseSetDao.getByExerciseId(
        exerciseModel.id!,
      );

      final exerciseSetEntities = exerciseSetModels
          .map((set) => set.toEntity())
          .toList();
      if (kDebugMode) {
        for (final exerciseSetEntity in exerciseSetEntities) {
          debugPrint("\tSet of exercise found: $exerciseSetEntity");
        }
      }
      return exerciseModel.toEntity(
        exerciseType: exerciseTypeModel.toEntity(),
        sets: exerciseSetEntities,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Exercise>> getExercisesOfType({
    required int typeId,
    int limit = 20,
  }) async {
    try {
      // Verify type exists
      final exerciseType = await _exerciseTypeDao.getById(typeId);
      if (exerciseType == null) {
        throw WorkoutDataException('ExerciseType with ID $typeId not found.');
      }

      // Get all exercises of that type
      final exerciseModels = await _exerciseDao.getByExerciseTypeId(
        exerciseTypeId: typeId,
        limit: limit,
      );

      // If there are no exercises of that type, then return an empty list
      if (exerciseModels.isEmpty) return <Exercise>[];

      final exerciseIds = exerciseModels
          .where((exercise) => exercise.id != null)
          .map((exercise) => exercise.id!)
          .toList();

      // Get all sets for all our exercises
      final allSets = await _exerciseSetDao.getBatchByExerciseIds(exerciseIds);

      // Create a map from exercise id to associated sets
      final setsByExerciseId = <int, List<ExerciseSetModel>>{};
      for (final set in allSets) {
        if (set.exerciseId != null) {
          setsByExerciseId.putIfAbsent(set.exerciseId!, () => []).add(set);
        }
      }

      // Create a List of Exercise entities with the help of our map
      final completeExerciseEntities = exerciseModels
          .where((exercise) => exercise.id != null)
          .map((exercise) {
            final exerciseId = exercise.id!;
            final sets = setsByExerciseId[exerciseId] ?? <ExerciseSetModel>[];
            final entitySets = sets.map((set) => set.toEntity()).toList();

            return exercise.toEntity(
              exerciseType: exerciseType.toEntity(),
              sets: entitySets,
            );
          })
          .toList();

      return completeExerciseEntities;
    } on WorkoutDataException {
      rethrow;
    } on DatabaseException catch (e) {
      throw WorkoutDataException(
        'Failed to load exercises of type $typeId: $e',
      );
    } catch (e) {
      throw WorkoutDataException(
        'Unexpected error loading exercises of type $typeId: $e',
      );
    }
  }

  Future<List<ExerciseType>> getExerciseTypes({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final exerciseTypeModels = await _exerciseTypeDao.getAll(
      limit: limit,
      offset: offset,
      txn: txn,
    );
    return exerciseTypeModels.map((model) => model.toEntity()).toList();
  }

  Future<int> createWorkout(Workout workout) async {
    final workoutModel = WorkoutModel.fromEntity(workout);
    return await _workoutDao.insert(workoutModel);
  }

  Future<void> createWorkouts(List<Workout> workouts) async {
    if (workouts.isEmpty) return;

    try {
      final db = await _db.database;
      return await db.transaction<void>((txn) async {
        for (final workout in workouts) {
          // Pass the transaction to each DAO operation
          final workoutId = await _workoutDao.insertWithTransaction(
            WorkoutModel.fromEntity(workout),
            txn,
          );

          for (final exercise in workout.exercises) {
            int exerciseTypeId;

            if (exercise.exerciseType.id != null) {
              exerciseTypeId = exercise.exerciseType.id!;
            } else {
              final existingExerciseTypeByName = await _exerciseTypeDao
                  .getByName(exercise.exerciseType.name, txn);
              if (existingExerciseTypeByName != null) {
                exerciseTypeId = existingExerciseTypeByName.id!;
              } else {
                exerciseTypeId = await _exerciseTypeDao.insert(
                  ExerciseTypeModel.fromEntity(exercise.exerciseType),
                  txn,
                );
              }
            }

            final exerciseModel = ExerciseModel.fromEntity(
              entity: exercise.copyWith(
                exerciseType: exercise.exerciseType.copyWith(
                  id: exerciseTypeId,
                ),
              ),
              workoutId: workoutId,
            );
            final exerciseId = await _exerciseDao.insertWithTransaction(
              exercise: exerciseModel,
              txn: txn,
            );

            if (exercise.sets.isNotEmpty) {
              final setModels = exercise.sets
                  .map(
                    (set) => ExerciseSetModel.fromEntity(
                      entity: set,
                      exerciseId: exerciseId,
                    ),
                  )
                  .toList();
              await _exerciseSetDao.batchInsertWithTransaction(
                sets: setModels,
                txn: txn,
              );
            }
          }
        }
      });
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to create workouts: $e');
    } catch (e) {
      throw WorkoutDataException('Unexpected error creating workouts: $e');
    }
  }

  Future<int> createExercise({
    required Exercise exercise,
    required int workoutId,
  }) async {
    final exerciseModel = ExerciseModel.fromEntity(
      entity: exercise,
      workoutId: workoutId,
    );
    return await _exerciseDao.insert(exerciseModel);
  }

  Future<int> createExerciseType(ExerciseType type) async {
    final typeModel = ExerciseTypeModel.fromEntity(type);
    return await _exerciseTypeDao.insert(typeModel);
  }

  Future<int> createExerciseSet({
    required ExerciseSet set,
    required int exerciseId,
  }) async {
    final setModel = ExerciseSetModel.fromEntity(
      entity: set,
      exerciseId: exerciseId,
    );
    return await _exerciseSetDao.insert(setModel);
  }

  Future<void> updateWorkout(Workout entity) async {
    final workoutModel = WorkoutModel.fromEntity(entity);
    await _workoutDao.update(workoutModel);
  }

  Future<void> updateExercise({
    required Exercise entity,
    required int workoutId,
  }) async {
    final exerciseModel = ExerciseModel.fromEntity(
      entity: entity,
      workoutId: workoutId,
    );
    await _exerciseDao.update(exerciseModel);
  }

  Future<void> updateExerciseType(ExerciseType entity) async {
    final exerciseTypeModel = ExerciseTypeModel.fromEntity(entity);
    await _exerciseTypeDao.updateById(exerciseTypeModel);
  }

  Future<void> updateExerciseSet({
    required ExerciseSet entity,
    required int exerciseId,
  }) async {
    final exerciseSetModel = ExerciseSetModel.fromEntity(
      entity: entity,
      exerciseId: exerciseId,
    );
    await _exerciseSetDao.update(exerciseSetModel);
  }

  Future<int> deleteWorkout(int id) async {
    return await _workoutDao.delete(id);
  }

  Future<int> deleteExercise(int id) async {
    return await _exerciseDao.delete(id);
  }

  Future<bool> deleteExerciseType(int id) async {
    return await _exerciseTypeDao.deleteById(id);
  }

  Future<int> deleteExerciseSet(int id) async {
    return await _exerciseSetDao.delete(id);
  }

  Future<void> clearWorkouts() async {
    await _workoutDao.clearTable();
  }

  Future<void> seedWorkouts() async {
    await createWorkouts(SeedData.sampleWorkouts);
  }
}
