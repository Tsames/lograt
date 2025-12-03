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

  void expectExercisesEqual(ExerciseModel? actual, ExerciseModel expected) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected exercise to exist but got null',
    );

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    for (final field in ExerciseFields.values) {
      expect(
        actualMap[field],
        equals(expectedMap[field]),
        reason: 'Field "$field" does not match',
      );
    }
  }

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
        expectExercisesEqual(retrieved, testExercise);
      });

      test('should handle inserting exercise with minimal data', () async {
        final minimalExercise = ExerciseModel.forTest(
          workoutId: testWorkout.id,
        );

        await exerciseDao.insert(minimalExercise);

        final retrieved = await exerciseDao.getById(minimalExercise.id);
        expectExercisesEqual(retrieved, minimalExercise);
      });

      test(
        'should throw exception when inserting exercise with duplicate id',
        () async {
          final otherExercise = testExercise.copyWith(
            order: testExercise.order + 1,
          );
          await exerciseDao.insert(testExercise);
          expect(
            () async => await exerciseDao.insert(otherExercise),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await exerciseDao.insert(testExercise, txn);
          final retrieved = await exerciseDao.getById(testExercise.id, txn);
          expectExercisesEqual(retrieved, testExercise);
        });

        // Verify it persisted after transaction
        final retrieved = await exerciseDao.getById(testExercise.id);
        expectExercisesEqual(retrieved, testExercise);
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
        expectExercisesEqual(allExercises[0], exercises[0]);
        expectExercisesEqual(allExercises[1], exercises[1]);
        expectExercisesEqual(allExercises[2], exercises[2]);
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

        expectExercisesEqual(workout1Exercises[0], exercises[0]);
        expectExercisesEqual(workout2Exercises[0], exercises[1]);
      });

      test(
        'should throw exception when batch insert has duplicate id among valid exercises',
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
          expectExercisesEqual(allExercises.first, testExercise);
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await exerciseDao.insert(testExercise);
      });

      test('should retrieve exercise by id correctly', () async {
        final retrieved = await exerciseDao.getById(testExercise.id);

        expectExercisesEqual(retrieved, testExercise);
      });

      test('should return null when exercise does not exist', () async {
        final nonExistent = await exerciseDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve all exercises for a workout', () async {
        final workout2 = WorkoutModel.forTest(title: 'Other Workout');
        await workoutDao.insert(workout2);

        final exercise2 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 2,
        );
        final exercise3 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 3,
        );
        final exercise4 = ExerciseModel.forTest(
          workoutId: workout2.id,
          order: 1,
        );

        await exerciseDao.insert(exercise2);
        await exerciseDao.insert(exercise3);
        await exerciseDao.insert(exercise4);

        final allExercises = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );

        expect(allExercises.length, equals(3));
        expect(allExercises, everyElement(isA<ExerciseModel>()));
        expectExercisesEqual(allExercises[0], testExercise);
        expectExercisesEqual(allExercises[1], exercise2);
        expectExercisesEqual(allExercises[2], exercise3);
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

    group('Get Most Recent Exercise By Exercise Type', () {
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
        expectExercisesEqual(mostRecent, newExercise);
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
        'should return exercise with highest order when multiple exercises in same workout',
        () async {
          final exercise2 = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            exerciseTypeId: testExerciseType.id,
            order: 2,
          );

          await exerciseDao.insert(testExercise); // order: 1
          await exerciseDao.insert(exercise2); // order: 2

          final mostRecent = await exerciseDao
              .getMostRecentExerciseThatHasExerciseTypeId(testExerciseType.id);
          expectExercisesEqual(mostRecent, exercise2);
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
        await exerciseDao.update(updatedExercise);

        final retrieved = await exerciseDao.getById(testExercise.id);
        expectExercisesEqual(retrieved, updatedExercise);
      });

      test(
        'should throw an exception when trying to update non-existent exercise',
        () async {
          final nonExistentExercise = ExerciseModel(
            id: '99999',
            workoutId: testWorkout.id,
            order: 1,
          );

          expect(
            () async => await exerciseDao.update(nonExistentExercise),
            throwsA(isA<Exception>()),
          );
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

        final updatedExercises = [
          exercises[0].copyWith(notes: 'Updated 1'),
          exercises[1].copyWith(notes: 'Updated 2'),
          exercises[2].copyWith(notes: 'Updated 3'),
        ];

        await exerciseDao.batchUpdate(updatedExercises);

        final retrieved1 = await exerciseDao.getById(exercises[0].id);
        final retrieved2 = await exerciseDao.getById(exercises[1].id);
        final retrieved3 = await exerciseDao.getById(exercises[2].id);

        expectExercisesEqual(retrieved1, updatedExercises[0]);
        expectExercisesEqual(retrieved2, updatedExercises[1]);
        expectExercisesEqual(retrieved3, updatedExercises[2]);
      });

      test('should handle empty list gracefully in batch update', () async {
        await exerciseDao.insert(testExercise);

        await exerciseDao.batchUpdate([]);

        final retrieved = await exerciseDao.getById(testExercise.id);
        expectExercisesEqual(retrieved, testExercise);
      });

      test(
        'should throw exception and rollback all updates when one exercise does not exist',
        () async {
          final existingExercise = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            order: 1,
            notes: 'Original',
          );
          await exerciseDao.insert(existingExercise);

          final nonExistentExercise = ExerciseModel(
            id: 'non-existent',
            workoutId: testWorkout.id,
            order: 2,
          );
          final updatedExisting = existingExercise.copyWith(
            notes: 'Should not persist',
          );

          expect(
            () async => await exerciseDao.batchUpdate([
              updatedExisting,
              nonExistentExercise,
            ]),
            throwsA(isA<Exception>()),
          );

          // Verify rollback - original data unchanged
          final retrieved = await exerciseDao.getById(existingExercise.id);
          expect(retrieved!.notes, equals('Original'));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await exerciseDao.insert(testExercise);
      });

      test('should delete existing exercise successfully', () async {
        await exerciseDao.delete(testExercise.id);
        final retrieved = await exerciseDao.getById(testExercise.id);
        expect(retrieved, isNull);
      });

      test(
        'should throw an exception when trying to delete non-existent exercise',
        () async {
          expect(
            () async => await exerciseDao.delete('99999'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Foreign Key Constraints', () {
      test('should CASCADE delete exercises when workout is deleted', () async {
        await exerciseDao.insert(testExercise);

        // Verify exercise exists
        final beforeDelete = await exerciseDao.getById(testExercise.id);
        expect(beforeDelete, isNotNull);

        // Delete the workout
        await workoutDao.delete(testWorkout.id);

        // Exercise should be automatically deleted due to CASCADE
        final afterDelete = await exerciseDao.getById(testExercise.id);
        expect(afterDelete, isNull);
      });

      test(
        'should CASCADE delete exercises when exercise type is deleted',
        () async {
          final workout = WorkoutModel.forTest(title: 'Test Workout');
          await workoutDao.insert(workout);

          final exercise = ExerciseModel.forTest(
            workoutId: workout.id,
            exerciseTypeId: testExerciseType.id,
            order: 1,
          );
          await exerciseDao.insert(exercise);

          // Verify exercise exists
          final exerciseBeforeDelete = await exerciseDao.getById(exercise.id);
          expect(exerciseBeforeDelete, isNotNull);

          // Delete the exercise type
          await exerciseTypeDao.delete(testExerciseType.id);

          // Exercise should be automatically deleted due to CASCADE
          final exerciseAfterDelete = await exerciseDao.getById(exercise.id);
          expect(exerciseAfterDelete, isNull);

          // Exercise type should be deleted
          final typeAfterDelete = await exerciseTypeDao.getById(
            testExerciseType.id,
          );
          expect(typeAfterDelete, isNull);
        },
      );
    });
  });
}
