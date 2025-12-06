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
import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/exceptions/workout_exceptions.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_exercise_type_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_template_model.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
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

  final WorkoutTemplateDao _workoutTemplateDao;
  final ExerciseTemplateDao _exerciseTemplateDao;
  final ExerciseSetTemplateDao _exerciseSetTemplateDao;

  final MuscleGroupDao _muscleGroupDao;
  final MuscleGroupToWorkoutDao _muscleGroupToWorkoutDao;
  final MuscleGroupToWorkoutTemplateDao _muscleGroupToWorkoutTemplateDao;
  final MuscleGroupToExerciseTypeDao _muscleGroupToExerciseTypeDao;

  WorkoutRepository({
    required AppDatabase databaseConnection,
    required WorkoutDao workoutDao,
    required ExerciseDao exerciseDao,
    required ExerciseTypeDao exerciseTypeDao,
    required ExerciseSetDao exerciseSetDao,
    required WorkoutTemplateDao workoutTemplateDao,
    required ExerciseTemplateDao exerciseTemplateDao,
    required ExerciseSetTemplateDao exerciseSetTemplateDao,
    required MuscleGroupDao muscleGroupDao,
    required MuscleGroupToWorkoutDao muscleGroupToWorkoutDao,
    required MuscleGroupToWorkoutTemplateDao muscleGroupToWorkoutTemplateDao,
    required MuscleGroupToExerciseTypeDao muscleGroupToExerciseTypeDao,
  }) : _db = databaseConnection,
       _workoutDao = workoutDao,
       _exerciseDao = exerciseDao,
       _exerciseTypeDao = exerciseTypeDao,
       _exerciseSetDao = exerciseSetDao,
       _workoutTemplateDao = workoutTemplateDao,
       _exerciseTemplateDao = exerciseTemplateDao,
       _exerciseSetTemplateDao = exerciseSetTemplateDao,
       _muscleGroupDao = muscleGroupDao,
       _muscleGroupToWorkoutDao = muscleGroupToWorkoutDao,
       _muscleGroupToWorkoutTemplateDao = muscleGroupToWorkoutTemplateDao,
       _muscleGroupToExerciseTypeDao = muscleGroupToExerciseTypeDao;

  /// Get a list of maximum length [limit] of [Workout]s order by creation date (descending)
  /// Each workout has its corresponding [WorkoutTemplate] if it exists as well as any [MuscleGroup]s assigned to the workout.
  /// The full [Exercise] and [ExerciseSet] data is omitted.
  Future<List<Workout>> getWorkoutSummariesPaginated({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    try {
      final workoutModels = await _workoutDao.getAllPaginatedOrderedByDate(
        limit: limit,
        offset: offset,
        txn: txn,
      );
      if (workoutModels.isEmpty) return const <Workout>[];

      final templateIds = workoutModels
          .map((workoutModel) => workoutModel.templateId)
          .nonNulls
          .toList();
      final workoutTemplateModels = templateIds.isNotEmpty
          ? await _workoutTemplateDao.getWorkoutTemplatesByIds(templateIds, txn)
          : const <WorkoutTemplateModel>[];

      final muscleGroupToWorkoutModels = await _muscleGroupToWorkoutDao
          .getRelationshipsByWorkoutIds(
            workoutModels
                .map((workoutModel) => workoutModel.id)
                .nonNulls
                .toList(),
            txn,
          );

      final muscleGroupsModels = muscleGroupToWorkoutModels.isNotEmpty
          ? await _muscleGroupDao.getMuscleGroupsByIds(
              muscleGroupToWorkoutModels
                  .map((relationship) => relationship.muscleGroupId)
                  .toList(),
              txn,
            )
          : const <MuscleGroupModel>[];

      final Map<String, WorkoutTemplate> workoutTemplates = {
        for (var model in workoutTemplateModels) model.id: model.toEntity(),
      };
      final Map<String, List<String>> workoutToMuscleGroupIds = {};
      for (var rel in muscleGroupToWorkoutModels) {
        workoutToMuscleGroupIds
            .putIfAbsent(rel.workoutId, () => [])
            .add(rel.muscleGroupId);
      }

      final Map<String, MuscleGroup> muscleGroups = {
        for (var model in muscleGroupsModels) model.id: model.toEntity(),
      };

      return workoutModels
          .map(
            (workoutModel) => workoutModel.toEntity(
              template: workoutTemplates.containsKey(workoutModel.templateId)
                  ? workoutTemplates[workoutModel.templateId]
                  : null,
              muscleGroups: (workoutToMuscleGroupIds[workoutModel.id] ?? [])
                  .map((mgId) => muscleGroups[mgId])
                  .whereType<MuscleGroup>()
                  .toList(),
            ),
          )
          .nonNulls
          .toList();
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
      final exerciseModels = await _exerciseDao.getAllExercisesWithWorkoutId(
        workoutId,
      );
      if (exerciseModels.isEmpty) {
        return workoutModel.toEntity();
      }

      final exerciseEntityFutures = exerciseModels.map((exerciseModel) async {
        final exerciseTypeModel = switch (exerciseModel.exerciseTypeId) {
          null => null,
          _ => await _exerciseTypeDao.getById(exerciseModel.exerciseTypeId!),
        };

        final exerciseSetModels = await _exerciseSetDao
            .getAllSetsWithExerciseId(exerciseModel.id);
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
    final exerciseTypeModels = await _exerciseTypeDao.getAllPaginated(
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

  Future<void> deleteWorkout(String id) async {
    return await _workoutDao.delete(id);
  }

  Future<void> deleteExercise(String id) async {
    return await _exerciseDao.delete(id);
  }

  Future<void> deleteExerciseType(String id) async {
    return await _exerciseTypeDao.delete(id);
  }

  Future<void> deleteExerciseSet(String id) async {
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

  Future<void> seedWorkoutData(List<Workout> workouts) async {
    try {
      final db = await _db.database;
      return await db.transaction<void>((txn) async {
        await _workoutDao.clearTable(txn);
        await _exerciseTypeDao.clearTable(txn);
        await _muscleGroupDao.clearTable(txn);
        await _workoutTemplateDao.clearTable(txn);

        if (workouts.isEmpty) return;

        final Set<ExerciseType> exerciseTypes = {}
          ..addAll(
            workouts
                .expand((workout) => workout.exercises)
                .map((exercise) => exercise.exerciseType)
                .nonNulls,
          )
          ..addAll(
            workouts
                .map((workout) => workout.template)
                .nonNulls
                .expand((template) => template.exerciseTemplates)
                .map((exerciseTemplate) => exerciseTemplate.exerciseType)
                .nonNulls,
          );
        await _exerciseTypeDao.batchInsert(
          exerciseTypes
              .map((exerciseType) => ExerciseTypeModel.fromEntity(exerciseType))
              .toList(),
          txn,
        );

        final Set<MuscleGroup> muscleGroups = {}
          ..addAll(workouts.expand((workout) => workout.muscleGroups))
          ..addAll(
            exerciseTypes.expand((exerciseType) => exerciseType.muscleGroups),
          );
        await _muscleGroupDao.batchInsert(
          muscleGroups
              .map((muscleGroup) => MuscleGroupModel.fromEntity(muscleGroup))
              .toList(),
          txn,
        );

        final Set<WorkoutTemplate> workoutTemplates = {}
          ..addAll(workouts.map((workout) => workout.template).nonNulls);
        await _workoutTemplateDao.batchInsert(
          workoutTemplates
              .map(
                (workoutTemplate) =>
                    WorkoutTemplateModel.fromEntity(workoutTemplate),
              )
              .toList(),
          txn,
        );

        await _workoutDao.batchInsert(
          workouts.map((workout) => WorkoutModel.fromEntity(workout)).toList(),
          txn,
        );

        await _exerciseDao.batchInsert(
          workouts
              .expand(
                (workout) => workout.exercises.map(
                  (exercise) => ExerciseModel.fromEntity(exercise, workout.id),
                ),
              )
              .toList(),
          txn,
        );

        await _exerciseSetDao.batchInsert(
          workouts
              .expand((workout) => workout.exercises)
              .expand(
                (exercise) => exercise.sets.map(
                  (set) => ExerciseSetModel.fromEntity(
                    entity: set,
                    exerciseId: exercise.id,
                  ),
                ),
              )
              .toList(),
          txn,
        );

        await _exerciseTemplateDao.batchInsert(
          workoutTemplates
              .expand(
                (workoutTemplate) => workoutTemplate.exerciseTemplates.map(
                  (exerciseTemplate) => ExerciseTemplateModel.fromEntity(
                    exerciseTemplate,
                    workoutTemplate.id,
                  ),
                ),
              )
              .toList(),
          txn,
        );

        await _exerciseSetTemplateDao.batchInsert(
          workoutTemplates
              .expand((workoutTemplate) => workoutTemplate.exerciseTemplates)
              .expand(
                (exerciseTemplate) => exerciseTemplate.setTemplates.map(
                  (setTemplate) => ExerciseSetTemplateModel.fromEntity(
                    entity: setTemplate,
                    exerciseTemplateId: exerciseTemplate.id,
                  ),
                ),
              )
              .toList(),
          txn,
        );

        await _muscleGroupToWorkoutDao.batchInsertRelationships(
          workouts
              .expand(
                (workout) => workout.muscleGroups.map(
                  (muscleGroup) => MuscleGroupToWorkoutModel.createWithId(
                    workoutId: workout.id,
                    muscleGroupId: muscleGroup.id,
                  ),
                ),
              )
              .toList(),
          txn,
        );

        await _muscleGroupToWorkoutTemplateDao.batchInsertRelationships(
          workoutTemplates
              .expand(
                (template) => template.muscleGroups.map(
                  (muscleGroup) =>
                      MuscleGroupToWorkoutTemplateModel.createWithId(
                        workoutTemplateId: template.id,
                        muscleGroupId: muscleGroup.id,
                      ),
                ),
              )
              .toList(),
          txn,
        );

        await _muscleGroupToExerciseTypeDao.batchInsertRelationships(
          exerciseTypes
              .expand(
                (exerciseType) => exerciseType.muscleGroups.map(
                  (muscleGroup) => MuscleGroupToExerciseTypeModel.createWithId(
                    muscleGroupId: muscleGroup.id,
                    exerciseTypeId: exerciseType.id,
                  ),
                ),
              )
              .toList(),
          txn,
        );
      });
    } on DatabaseException catch (e) {
      throw Exception('Failed to seed database: $e');
    } catch (e) {
      throw WorkoutDataException('Unexpected error creating workouts: $e');
    }
  }
}
