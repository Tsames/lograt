import 'package:lograt/data/database/dao/exercise_dao.dart';
import 'package:lograt/data/database/dao/exercise_set_dao.dart';
import 'package:lograt/data/database/dao/exercise_type_dao.dart';
import 'package:lograt/data/database/workout_seed.dart';
import 'package:lograt/data/models/exercise_model.dart';
import 'package:lograt/domain/entities/exercise_type.dart';
import 'package:lograt/domain/entities/workout_summary.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout.dart';
import '../../domain/exceptions/workout_exceptions.dart';
import '../../domain/repository/workout_repository.dart';
import '../database/dao/workout_dao.dart';
import '../models/exercise_set_model.dart';
import '../models/exercise_type_model.dart';
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

  /// Get most a list (max length [limit]) of the most recent [WorkoutSummary] within 3 months.
  /// Main method for populating the recent workouts page.
  @override
  Future<List<WorkoutSummary>> getMostRecentSummaries(int limit) async {
    final workoutSummaryModels = await _workoutDao.getRecentSummaries();
    final workoutSummaryEntities = workoutSummaryModels.map((workoutModel) => workoutModel.toEntity()).toList();

    return workoutSummaryEntities;
  }

  /// Get a [Workout] including all its associated exercises and their associated sets by [workoutId].
  /// Main method for retrieving data necessary for the workout details and log page.
  @override
  Future<Workout> getFullWorkoutDetails(int workoutId) async {
    try {
      // Get the workout in question
      final workoutModel = await _workoutDao.getById(workoutId);
      if (workoutModel == null) {
        throw WorkoutNotFoundException(workoutId);
      }

      // Get all exercises for the workout
      final exerciseModels = await _exerciseDao.getByWorkoutId(workoutId);
      if (exerciseModels.isEmpty) {
        return workoutModel.toEntity(exercises: []);
      }

      final exerciseEntityFutures = exerciseModels.map((exerciseModel) async {
        return await _buildExerciseEntity(exerciseModel);
      }).toList();

      final exerciseEntities = await Future.wait(exerciseEntityFutures);

      final validExercises = exerciseEntities.whereType<Exercise>().toList();

      return workoutModel.toEntity(exercises: validExercises);
    } on WorkoutNotFoundException {
      rethrow;
    } on DatabaseException catch (e) {
      throw WorkoutDataException('Failed to load workout details for workout $workoutId: $e');
    } catch (e) {
      throw WorkoutDataException('Unexpected error loading workout $workoutId: $e');
    }
  }

  /// Helper method to [getFullWorkoutDetails] that builds an [Exercise] with all its associated sets from an [ExerciseModel].
  /// Returns null if an error is encountered or no [ExerciseType] can be found in the database.
  Future<Exercise?> _buildExerciseEntity(ExerciseModel exerciseModel) async {
    try {
      if (exerciseModel.exerciseTypeId == null) {
        return null;
      }
      final exerciseTypeModel = await _exerciseTypeDao.getById(exerciseModel.exerciseTypeId!);
      if (exerciseTypeModel == null) {
        return null;
      }

      final exerciseSetModels = await _exerciseSetDao.getByExerciseId(exerciseModel.id!);
      if (exerciseSetModels == null) {
        return exerciseModel.toEntity(exerciseType: exerciseTypeModel.toEntity(), sets: const []);
      }

      final exerciseSetEntity = exerciseSetModels.map((set) => set.toEntity()).toList();
      return exerciseModel.toEntity(exerciseType: exerciseTypeModel.toEntity(), sets: exerciseSetEntity);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> createWorkout(Workout workout) async {
    final workoutModel = WorkoutModel.fromEntity(workout);
    return await _workoutDao.insert(workoutModel);
  }

  @override
  Future<int> createExercise({required Exercise exercise, required int workoutId}) async {
    final exerciseModel = ExerciseModel.fromEntity(entity: exercise, workoutId: workoutId);
    return await _exerciseDao.insert(exerciseModel);
  }

  @override
  Future<int> createExerciseType(ExerciseType type) async {
    final typeModel = ExerciseTypeModel.fromEntity(type);
    return await _exerciseTypeDao.insert(typeModel);
  }

  @override
  Future<int> createExerciseSet({required ExerciseSet set, required int exerciseId}) async {
    final setModel = ExerciseSetModel.fromEntity(entity: set, exerciseId: exerciseId);
    return await _exerciseSetDao.insert(setModel);
  }

  @override
  Future<void> updateWorkout(Workout updatedWorkout) async {
    final workoutModel = WorkoutModel.fromEntity(updatedWorkout);
    await _workoutDao.update(workoutModel);
  }

  @override
  Future<void> updateExercise({required Exercise updatedExercise, required int workoutId}) async {
    final exerciseModel = ExerciseModel.fromEntity(entity: updatedExercise, workoutId: workoutId);
    await _exerciseDao.update(exerciseModel);
  }

  @override
  Future<void> updateExerciseType(ExerciseType updatedType) async {
    final exerciseTypeModel = ExerciseTypeModel.fromEntity(updatedType);
    await _exerciseTypeDao.update(exerciseTypeModel);
  }

  @override
  Future<void> updateExerciseSet({required ExerciseSet updatedSet, required int exerciseId}) async {
    final exerciseSetModel = ExerciseSetModel.fromEntity(entity: updatedSet, exerciseId: exerciseId);
    await _exerciseSetDao.update(exerciseSetModel);
  }

  @override
  Future<void> addWorkouts(List<Workout> workouts) async {
    // Convert all domain entities to data models
    final workoutModels = workouts.map(WorkoutModel.fromEntity).toList();
    for (final workoutModel in workoutModels) {
      await _workoutDao.insert(workoutModel);
    }
  }

  @override
  Future<void> clearWorkouts() async {
    await _workoutDao.clearTable();
  }

  @override
  Future<void> seedWorkouts() async {
    final seedWorkouts = WorkoutSeed.sampleWorkouts.map((model) => model.toEntity()).toList();
    await addWorkouts(seedWorkouts);
  }
}
