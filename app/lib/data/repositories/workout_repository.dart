import 'package:lograt/data/dao/exercise_dao.dart';
import 'package:lograt/data/dao/exercise_set_dao.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/database/seed_data.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/exceptions/workout_exceptions.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite/sqflite.dart';

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
  Future<Workout?> getWorkoutSummary(String workoutId) async {
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

  Future<ExerciseSet?> getExerciseSet(String setId) async {
    try {
      final setModel = await _exerciseSetDao.getById(setId);

      return setModel?.toEntity();
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
  Future<Workout> getFullWorkoutDetails(String workoutId) async {
    try {
      // Get the workout in question
      final workoutModel = await _workoutDao.getById(workoutId);
      if (workoutModel == null) {
        throw WorkoutNotFoundException(workoutId);
      }

      // Get all exercises for the workout
      final exerciseModels = await _exerciseDao.getByWorkoutId(workoutId);
      if (exerciseModels.isEmpty) {
        return workoutModel.toEntity();
      }

      final exerciseEntityFutures = exerciseModels.map((exerciseModel) async {
        final exerciseTypeModel = switch (exerciseModel.exerciseTypeId) {
          null => null,
          _ => await _exerciseTypeDao.getById(exerciseModel.exerciseTypeId!),
        };

        final exerciseSetModels = await _exerciseSetDao.getByExerciseId(
          exerciseModel.id,
        );
        final exerciseSetEntities = exerciseSetModels
            .map((set) => set.toEntity())
            .toList();

        return exerciseModel.toEntity(
          exerciseTypeModel?.toEntity(),
          exerciseSetEntities,
        );
      }).toList();

      final exerciseEntities = await Future.wait(exerciseEntityFutures);

      final validExercises = exerciseEntities.nonNulls.toList();

      return workoutModel.toEntity(exercises: validExercises);
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

  Future<void> createWorkout(Workout workout) async {
    final workoutModel = WorkoutModel.fromEntity(workout);
    await _workoutDao.insert(workoutModel);
  }

  Future<void> batchCreateWorkouts(List<Workout> workouts) async {
    if (workouts.isEmpty) return;

    try {
      final db = await _db.database;
      // Pass the transaction to each DAO operation
      return await db.transaction<void>((txn) async {
        for (final workout in workouts) {
          // Create Workout
          await _workoutDao.insertWithTransaction(
            WorkoutModel.fromEntity(workout),
            txn,
          );

          for (final exercise in workout.exercises) {
            // If the exercise has an exercise type, check if it already exists in the database, if it doesn't create it
            if (exercise.exerciseType != null) {
              final existingExerciseTypeById = await _exerciseTypeDao.getByName(
                exercise.exerciseType!.name,
                txn,
              );
              if (existingExerciseTypeById == null) {
                await _exerciseTypeDao.insert(
                  ExerciseTypeModel.fromEntity(exercise.exerciseType!),
                  txn,
                );
              }
            }

            // Create exercise
            await _exerciseDao.insertWithTransaction(
              exercise: ExerciseModel.fromEntity(exercise, workout.id),
              txn: txn,
            );

            // Create Sets
            if (exercise.sets.isNotEmpty) {
              final setModels = exercise.sets
                  .map(
                    (set) => ExerciseSetModel.fromEntity(
                      entity: set,
                      exerciseId: exercise.id,
                    ),
                  )
                  .toList();
              await _exerciseSetDao.batchInsert(setModels, txn);
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
    required String workoutId,
  }) async {
    final exerciseModel = ExerciseModel.fromEntity(exercise, workoutId);
    return await _exerciseDao.insert(exerciseModel);
  }

  Future<int> createExerciseType(ExerciseType type) async {
    final typeModel = ExerciseTypeModel.fromEntity(type);
    return await _exerciseTypeDao.insert(typeModel);
  }

  Future<int> createExerciseSet({
    required ExerciseSet set,
    required String exerciseId,
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
    required String workoutId,
  }) async {
    final exerciseModel = ExerciseModel.fromEntity(entity, workoutId);
    await _exerciseDao.update(exerciseModel);
  }

  Future<void> updateExerciseType(ExerciseType entity) async {
    final exerciseTypeModel = ExerciseTypeModel.fromEntity(entity);
    await _exerciseTypeDao.updateById(exerciseTypeModel);
  }

  Future<void> updateExerciseSet({
    required ExerciseSet entity,
    required String exerciseId,
  }) async {
    final exerciseSetModel = ExerciseSetModel.fromEntity(
      entity: entity,
      exerciseId: exerciseId,
    );
    await _exerciseSetDao.update(exerciseSetModel);
  }

  Future<int> deleteWorkout(String id) async {
    return await _workoutDao.delete(id);
  }

  Future<int> deleteExercise(String id) async {
    return await _exerciseDao.delete(id);
  }

  Future<bool> deleteExerciseType(String id) async {
    return await _exerciseTypeDao.deleteById(id);
  }

  Future<bool> deleteExerciseSet(String id) async {
    return await _exerciseSetDao.delete(id);
  }

  Future<int> count(String table) async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      return result.first['count'] as int;
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to count $table: $e');
    }
  }

  Future<void> clearWorkouts() async {
    await _exerciseSetDao.clearTable();
    await _exerciseDao.clearTable();
    await _exerciseTypeDao.clearTable();
    await _workoutDao.clearTable();
  }

  Future<void> seedWorkouts() async {
    await batchCreateWorkouts(SeedData.sampleWorkouts);
  }
}
