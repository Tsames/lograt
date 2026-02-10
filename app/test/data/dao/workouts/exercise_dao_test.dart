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

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.order,
      equals(expected.order),
      reason: 'Field "order" does not match',
    );
    expect(
      actual.workoutId,
      equals(expected.workoutId),
      reason: 'Field "workoutId" does not match',
    );
    expect(
      actual.exerciseTypeId,
      equals(expected.exerciseTypeId),
      reason: 'Field "exerciseTypeId" does not match',
    );
    expect(
      actual.notes,
      equals(expected.notes),
      reason: 'Field "notes" does not match',
    );
  }

  group('ExerciseDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseDao exerciseDao;
    late WorkoutDao workoutDao;
    late ExerciseTypeDao exerciseTypeDao;

    late WorkoutModel testWorkout;
    late ExerciseTypeModel testExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseDao = ExerciseDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testWorkout = WorkoutModel.forTest(title: 'Test Workout');
      await workoutDao.insert(testWorkout);

      testExerciseType = ExerciseTypeModel.forTest(name: 'Bench Press');
      await exerciseTypeDao.insert(testExerciseType);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllExercisesWithWorkoutId', () {
      test('should retrieve all exercises for a workout', () async {
        final exercises = [
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 1),
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 2),
          ExerciseModel.forTest(workoutId: testWorkout.id, order: 3),
        ];

        await exerciseDao.batchInsert(exercises);

        final retrieved = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );

        expect(retrieved.length, equals(3));
      });

      test('should return empty list when workout has no exercises', () async {
        final exercises = await exerciseDao.getAllExercisesWithWorkoutId(
          testWorkout.id,
        );

        expect(exercises, isEmpty);
      });

      test('should only return exercises for specified workout', () async {
        final workout2 = WorkoutModel.forTest(title: 'Other Workout');
        await workoutDao.insert(workout2);

        final exercise1 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 1,
        );
        final exercise2 = ExerciseModel.forTest(
          workoutId: workout2.id,
          order: 1,
        );

        await exerciseDao.insert(exercise1);
        await exerciseDao.insert(exercise2);

        final workout1Exercises = await exerciseDao
            .getAllExercisesWithWorkoutId(testWorkout.id);
        final workout2Exercises = await exerciseDao
            .getAllExercisesWithWorkoutId(workout2.id);

        expect(workout1Exercises.length, equals(1));
        expect(workout2Exercises.length, equals(1));
        expectExercisesEqual(workout1Exercises[0], exercise1);
        expectExercisesEqual(workout2Exercises[0], exercise2);
      });
    });

    group('getMostRecentExerciseThatHasExerciseTypeId', () {
      test('should return most recent exercise for a given type', () async {
        final oldWorkout = WorkoutModel(
          id: 'old',
          date: DateTime(2024, 1, 1),
          title: 'Old',
        );
        final newWorkout = WorkoutModel(
          id: 'new',
          date: DateTime(2024, 12, 1),
          title: 'New',
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
              .getMostRecentExerciseThatHasExerciseTypeId('non-existent-type');

          expect(mostRecent, isNull);
        },
      );

      test(
        'should return highest order exercise when multiple in same workout',
        () async {
          final exercise1 = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            exerciseTypeId: testExerciseType.id,
            order: 1,
          );
          final exercise2 = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            exerciseTypeId: testExerciseType.id,
            order: 2,
          );

          await exerciseDao.insert(exercise1);
          await exerciseDao.insert(exercise2);

          final mostRecent = await exerciseDao
              .getMostRecentExerciseThatHasExerciseTypeId(testExerciseType.id);

          expectExercisesEqual(mostRecent, exercise2);
        },
      );
    });

    group('Foreign Key Constraints', () {
      test('should CASCADE delete exercises when workout is deleted', () async {
        final exercise = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 1,
        );
        await exerciseDao.insert(exercise);

        // Verify exercise exists
        expect(await exerciseDao.getById(exercise.id), isNotNull);

        // Delete the workout
        await workoutDao.delete(testWorkout.id);

        // Exercise should be deleted due to CASCADE
        expect(await exerciseDao.getById(exercise.id), isNull);
      });

      test(
        'should CASCADE delete exercises when exercise type is deleted',
        () async {
          final exercise = ExerciseModel.forTest(
            workoutId: testWorkout.id,
            exerciseTypeId: testExerciseType.id,
            order: 1,
          );
          await exerciseDao.insert(exercise);

          // Verify exercise exists
          expect(await exerciseDao.getById(exercise.id), isNotNull);

          // Delete the exercise type
          await exerciseTypeDao.delete(testExerciseType.id);

          // Exercise should be deleted due to CASCADE
          expect(await exerciseDao.getById(exercise.id), isNull);
        },
      );

      test(
        'should throw exception when inserting with non-existent workout',
        () async {
          final exercise = ExerciseModel(
            id: 'test',
            workoutId: 'non-existent',
            order: 1,
          );

          expect(
            () async => await exerciseDao.insert(exercise),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
