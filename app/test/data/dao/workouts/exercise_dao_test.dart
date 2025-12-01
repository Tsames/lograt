import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/workout/exercise_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('ExerciseDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseDao exerciseDao;
    late WorkoutDao workoutDao;
    late ExerciseTypeDao exerciseTypeDao;

    late WorkoutModel testWorkout;
    late ExerciseTypeModel testExerciseType;
    late ExerciseModel testExercise;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseDao = ExerciseDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      // Create prerequisite data
      testWorkout = WorkoutModel.forTest(title: 'Test Workout');
      await workoutDao.insert(testWorkout);

      testExerciseType = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      await exerciseTypeDao.insert(testExerciseType);

      testExercise = ExerciseModel.forTest(
        workoutId: testWorkout.id,
        exerciseTypeId: testExerciseType.id,
        order: 1,
        notes: 'Test exercise',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new exercise correctly', () async {
        await exerciseDao.insert(testExercise);

        final retrieved = await exerciseDao.getById(testExercise.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(testExercise.id));
        expect(retrieved.order, equals(testExercise.order));
        expect(retrieved.workoutId, equals(testWorkout.id));
        expect(retrieved.exerciseTypeId, equals(testExerciseType.id));
        expect(retrieved.notes, equals(testExercise.notes));
      });

      test('should handle inserting exercise with minimal data', () async {
        final minimalExercise = ExerciseModel.forTest(
          workoutId: testWorkout.id,
        );

        await exerciseDao.insert(minimalExercise);

        final retrieved = await exerciseDao.getById(minimalExercise.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(minimalExercise.id));
        expect(retrieved.order, equals(minimalExercise.order));
        expect(retrieved.workoutId, equals(minimalExercise.workoutId));
        expect(retrieved.exerciseTypeId, isNull);
        expect(retrieved.notes, isNull);
      });
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple exercises correctly', () async {
        final exercises = [
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 1),
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 2),
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 3),
        ];

        await exerciseDao.batchInsert(exercises);

        final allExercises = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );
        expect(allExercises.length, equals(3));
        expect(allExercises, everyElement(isA<ExerciseModel>()));

        expect(allExercises[0].id, equals(exercises[0].id));
        expect(allExercises[0].order, equals(exercises[0].order));
        expect(allExercises[0].workoutId, equals(exercises[0].workoutId));
        expect(
          allExercises[0].exerciseTypeId,
          equals(exercises[0].exerciseTypeId),
        );
        expect(allExercises[0].notes, equals(exercises[0].notes));

        expect(allExercises[1].id, equals(exercises[1].id));
        expect(allExercises[1].order, equals(exercises[1].order));
        expect(allExercises[1].workoutId, equals(exercises[1].workoutId));
        expect(
          allExercises[1].exerciseTypeId,
          equals(exercises[1].exerciseTypeId),
        );
        expect(allExercises[1].notes, equals(exercises[1].notes));

        expect(allExercises[2].id, equals(exercises[2].id));
        expect(allExercises[2].order, equals(exercises[2].order));
        expect(allExercises[2].workoutId, equals(exercises[2].workoutId));
        expect(
          allExercises[2].exerciseTypeId,
          equals(exercises[2].exerciseTypeId),
        );
        expect(allExercises[2].notes, equals(exercises[2].notes));
      });

      test('should handle empty list gracefully in batch insert', () async {
        await exerciseDao.batchInsert([]);

        final allExercises = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );
        expect(allExercises, isEmpty);
      });

      test('should batch insert exercises across multiple workouts', () async {
        final workout2 = WorkoutModel.forTest(title: 'Workout 2');
        await workoutDao.insert(workout2);

        final exercises = [
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 1),
          ExerciseModel.forTest(workoutId: workout2.id, order: 1),
        ];

        await exerciseDao.batchInsert(exercises);

        final workout1Exercises = await exerciseDao
            .getAllExercisesWithWorkoutId(testWorkout.id);
        final workout2Exercises = await exerciseDao
            .getAllExercisesWithWorkoutId(workout2.id);

        expect(workout1Exercises.length, equals(1));
        expect(workout2Exercises.length, equals(1));

        expect(workout1Exercises[0].id, equals(exercises[0].id));
        expect(workout1Exercises[0].order, equals(exercises[0].order));
        expect(workout1Exercises[0].workoutId, equals(exercises[0].workoutId));
        expect(
          workout1Exercises[0].exerciseTypeId,
          equals(exercises[0].exerciseTypeId),
        );
        expect(workout1Exercises[0].notes, equals(exercises[0].notes));

        expect(workout2Exercises[0].id, equals(exercises[1].id));
        expect(workout2Exercises[0].order, equals(exercises[1].order));
        expect(workout2Exercises[0].workoutId, equals(exercises[1].workoutId));
        expect(
          workout2Exercises[0].exerciseTypeId,
          equals(exercises[1].exerciseTypeId),
        );
        expect(workout2Exercises[0].notes, equals(exercises[1].notes));
      });

      test(
        'should throw database exception when batch insert has duplicate ID among valid exercises',
        () async {
          await exerciseDao.insert(testExercise);

          final exercises = [
            ExerciseModel.forTest(workoutId: testWorkout.id, order: 1),
            testExercise,
            ExerciseModel.forTest(workoutId: testWorkout.id, order: 2),
          ];

          expect(
            () async => await exerciseDao.batchInsert(exercises),
            throwsA(isA<DatabaseException>()),
          );

          final allExercises = await exerciseDao.getAllExercisesWithWorkoutId(
            testWorkout.id,
          );
          expect(allExercises.length, equals(1));
          expect(allExercises.first.id, equals(testExercise.id));
          expect(allExercises.first.order, equals(testExercise.order));
          expect(allExercises.first.workoutId, equals(testExercise.workoutId));
          expect(
            allExercises.first.exerciseTypeId,
            testExercise.exerciseTypeId,
          );
          expect(allExercises.first.notes, testExercise.notes);
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await exerciseDao.insert(testExercise);
      });

      test('should retrieve exercise by ID correctly', () async {
        final retrieved = await exerciseDao.getById(testExercise.id);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<ExerciseModel>());
        expect(retrieved!.id, equals(testExercise.id));
        expect(retrieved.order, equals(testExercise.order));
        expect(retrieved.workoutId, equals(testWorkout.id));
        expect(retrieved.exerciseTypeId, equals(testExerciseType.id));
        expect(retrieved.notes, equals(testExercise.notes));
      });

      test('should return null when exercise does not exist', () async {
        final nonExistent = await exerciseDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve all exercises for a workout', () async {
        final exercise2 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 2,
        );
        final exercise3 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 3,
        );
        final exercise4 = ExerciseModel.forTest(workoutId: '9999999', order: 1);

        await exerciseDao.insert(exercise2);
        await exerciseDao.insert(exercise3);
        await exerciseDao.insert(exercise4);

        final allExercises = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );

        expect(allExercises.length, equals(3));
        expect(allExercises, everyElement(isA<ExerciseModel>()));
        expect(allExercises[0].id, equals(testExercise.id));
        expect(allExercises[0].order, equals(testExercise.order));
        expect(allExercises[0].workoutId, equals(testExercise.workoutId));
        expect(
          allExercises[0].exerciseTypeId,
          equals(testExercise.exerciseTypeId),
        );
        expect(allExercises[0].notes, equals(testExercise.notes));

        expect(allExercises[1].id, equals(exercise2.id));
        expect(allExercises[1].order, equals(exercise2.order));
        expect(allExercises[1].workoutId, equals(exercise2.workoutId));
        expect(
          allExercises[1].exerciseTypeId,
          equals(exercise2.exerciseTypeId),
        );
        expect(allExercises[1].notes, equals(exercise2.notes));

        expect(allExercises[2].id, equals(exercise3.id));
        expect(allExercises[2].order, equals(exercise3.order));
        expect(allExercises[2].workoutId, equals(exercise3.workoutId));
        expect(
          allExercises[2].exerciseTypeId,
          equals(exercise3.exerciseTypeId),
        );
        expect(allExercises[2].notes, equals(exercise3.notes));
      });

      test('should return empty list when workout has no exercises', () async {
        final emptyWorkout = WorkoutModel.forTest(title: 'Empty Workout');
        await workoutDao.insert(emptyWorkout);

        final exercises = await exerciseDao.getAllExercisesWithWorkoutId(
          emptyWorkout.id,
        );

        expect(exercises, isEmpty);
        expect(exercises, isA<List<ExerciseModel>>());
      });
    });

    group('Get Most Recent Exercise By Type', () {
      test('should return most recent exercise for a given type', () async {
        final oldWorkout = WorkoutModel(
          id: 'old-workout',
          date: DateTime(2024, 1, 1),
          title: 'Old Workout',
        );
        final newWorkout = WorkoutModel(
          id: 'new-workout',
          date: DateTime(2024, 12, 1),
          title: 'New Workout',
        );

        await workoutDao.insert(oldWorkout);
        await workoutDao.insert(newWorkout);

        final oldExercise = ExerciseModel.forTest(
          workoutId: oldWorkout.id,
          exerciseTypeId: testExerciseType.id,
          order: 1,
        );
        final newExercise = ExerciseModel.forTest(
          workoutId: newWorkout.id,
          exerciseTypeId: testExerciseType.id,
          order: 1,
        );

        await exerciseDao.insert(oldExercise);
        await exerciseDao.insert(newExercise);

        final mostRecent = await exerciseDao
            .getMostRecentExerciseThatHasExerciseTypeId(testExerciseType.id);

        expect(mostRecent, isNotNull);
        expect(mostRecent!.id, equals(newExercise.id));
        expect(mostRecent.order, equals(newExercise.order));
        expect(mostRecent.workoutId, equals(newWorkout.id));
        expect(mostRecent.exerciseTypeId, equals(testExerciseType.id));
        expect(mostRecent.notes, equals(newExercise.notes));
      });

      test(
        'should return null when no exercise exists with given type',
        () async {
          final mostRecent = await exerciseDao
              .getMostRecentExerciseThatHasExerciseTypeId(
                'non-existent-type-id',
              );

          expect(mostRecent, isNull);
        },
      );

      test(
        'should handle multiple exercises in same workout correctly',
        () async {
          final exercise2 = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            exerciseTypeId: testExerciseType.id,
            order: 2,
          );

          await exerciseDao.insert(testExercise);
          await exerciseDao.insert(exercise2);

          final mostRecent = await exerciseDao
              .getMostRecentExerciseThatHasExerciseTypeId(testExerciseType.id);

          expect(mostRecent, isNotNull);
          expect(mostRecent!.id, equals(testExercise.id));
          expect(mostRecent.order, equals(testExercise.order));
          expect(mostRecent.workoutId, equals(testWorkout.id));
          expect(mostRecent.exerciseTypeId, equals(testExerciseType.id));
          expect(mostRecent.notes, equals(testExercise.notes));
        },
      );
    });

    group('Update Operations', () {
      setUp(() async {
        await exerciseDao.insert(testExercise);
      });

      test('should update existing exercise successfully', () async {
        final updatedExercise = testExercise.copyWith(
          order: 5,
          notes: 'Updated notes',
        );

        final rowsAffected = await exerciseDao.update(updatedExercise);

        expect(rowsAffected, equals(1));

        final retrieved = await exerciseDao.getById(testExercise.id);
        expect(retrieved!.id, equals(testExercise.id));
        expect(retrieved.order, equals(updatedExercise.order));
        expect(retrieved.workoutId, equals(testExercise.workoutId));
        expect(retrieved.exerciseTypeId, equals(testExercise.exerciseTypeId));
        expect(retrieved.notes, equals(updatedExercise.notes));
      });

      test(
        'should return 0 when trying to update non-existent exercise',
        () async {
          final nonExistentExercise = ExerciseModel(
            id: '99999',
            workoutId: testWorkout.id,
            order: 1,
          );

          final rowsAffected = await exerciseDao.update(nonExistentExercise);

          expect(rowsAffected, equals(0));
        },
      );
    });

    group('Batch Update Operations', () {
      test('should batch update multiple exercises correctly', () async {
        final exercises = [
          ExerciseModel.forTest(
            workoutId: testWorkout.id,
            order: 1,
            notes: 'Original 1',
          ),
          ExerciseModel.forTest(
            workoutId: testWorkout.id,
            order: 2,
            notes: 'Original 2',
          ),
          ExerciseModel.forTest(
            workoutId: testWorkout.id,
            order: 3,
            notes: 'Original 3',
          ),
        ];

        await exerciseDao.batchInsert(exercises);

        // Update all exercises
        final updatedExercises = [
          exercises[0].copyWith(notes: 'Updated 1'),
          exercises[1].copyWith(notes: 'Updated 2'),
          exercises[2].copyWith(notes: 'Updated 3'),
        ];

        await exerciseDao.batchUpdate(updatedExercises);

        final retrieved1 = await exerciseDao.getById(exercises[0].id);
        final retrieved2 = await exerciseDao.getById(exercises[1].id);
        final retrieved3 = await exerciseDao.getById(exercises[2].id);

        expect(retrieved1!.notes, equals('Updated 1'));
        expect(retrieved2!.notes, equals('Updated 2'));
        expect(retrieved3!.notes, equals('Updated 3'));
      });

      test('should handle empty list gracefully in batch update', () async {
        await exerciseDao.insert(testExercise);

        await exerciseDao.batchUpdate([]);

        // Exercise should remain unchanged
        final retrieved = await exerciseDao.getById(testExercise.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.notes, equals(testExercise.notes));
      });

      test(
        'should handle partial batch update when some exercises do not exist',
        () async {
          final existingExercise = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            order: 1,
            notes: 'Exists',
          );
          await exerciseDao.insert(existingExercise);

          final nonExistentExercise = ExerciseModel(
            id: 'non-existent',
            workoutId: testWorkout.id,
            order: 2,
            notes: 'Does not exist',
          );

          // Batch update should not throw error
          await exerciseDao.batchUpdate([
            existingExercise.copyWith(notes: 'Updated'),
            nonExistentExercise,
          ]);

          final retrieved = await exerciseDao.getById(existingExercise.id);
          expect(retrieved!.notes, equals('Updated'));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await exerciseDao.insert(testExercise);
      });

      test('should delete existing exercise successfully', () async {
        final rowsDeleted = await exerciseDao.delete(testExercise.id);

        expect(rowsDeleted, equals(1));

        final retrieved = await exerciseDao.getById(testExercise.id);
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent exercise',
        () async {
          final rowsDeleted = await exerciseDao.delete('99999');

          expect(rowsDeleted, equals(0));
        },
      );
    });
  });
}
