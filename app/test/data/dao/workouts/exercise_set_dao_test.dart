import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/workout/exercise_dao.dart';
import 'package:lograt/data/dao/workout/exercise_set_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectExerciseSetsEqual(
    ExerciseSetModel? actual,
    ExerciseSetModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected exercise set to exist but got null',
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
      actual.exerciseId,
      equals(expected.exerciseId),
      reason: 'Field "exerciseId" does not match',
    );
    expect(
      actual.setType,
      equals(expected.setType),
      reason: 'Field "setType" does not match',
    );
    expect(
      actual.weight,
      equals(expected.weight),
      reason: 'Field "weight" does not match',
    );
    expect(
      actual.units,
      equals(expected.units),
      reason: 'Field "units" does not match',
    );
    expect(
      actual.reps,
      equals(expected.reps),
      reason: 'Field "reps" does not match',
    );
    expect(
      actual.restTimeSeconds,
      equals(expected.restTimeSeconds),
      reason: 'Field "restTimeSeconds" does not match',
    );
  }

  group('ExerciseSetDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseSetDao exerciseSetDao;
    late WorkoutDao workoutDao;
    late ExerciseTypeDao exerciseTypeDao;
    late ExerciseDao exerciseDao;

    late WorkoutModel testWorkout;
    late ExerciseTypeModel testExerciseType;
    late ExerciseModel testExercise;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseSetDao = ExerciseSetDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);
      exerciseDao = ExerciseDao(testDatabase);

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
      await exerciseDao.insert(testExercise);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllSetsWithExerciseId', () {
      test(
        'should retrieve all sets for an exercise ordered by order ascending',
        () async {
          final sets = [
            ExerciseSetModel.forTest(
              exerciseId: testExercise.id,
              order: 3,
              weight: 155.0,
            ),
            ExerciseSetModel.forTest(
              exerciseId: testExercise.id,
              order: 1,
              weight: 135.0,
            ),
            ExerciseSetModel.forTest(
              exerciseId: testExercise.id,
              order: 2,
              weight: 145.0,
            ),
          ];

          await exerciseSetDao.batchInsert(sets);

          final retrieved = await exerciseSetDao.getAllSetsWithExerciseId(
            testExercise.id,
          );

          expect(retrieved.length, equals(3));

          // Verify ascending order by order field
          expectExerciseSetsEqual(retrieved[0], sets[1]);
          expectExerciseSetsEqual(retrieved[1], sets[2]);
          expectExerciseSetsEqual(retrieved[2], sets[0]);
        },
      );

      test('should return empty list when exercise has no sets', () async {
        final sets = await exerciseSetDao.getAllSetsWithExerciseId(
          testExercise.id,
        );

        expect(sets, isEmpty);
        expect(sets, isA<List<ExerciseSetModel>>());
      });

      test('should only return sets for specified exercise', () async {
        final exercise2 = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 2,
        );
        await exerciseDao.insert(exercise2);

        final set1 = ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 1,
          weight: 135.0,
        );
        final set2 = ExerciseSetModel.forTest(
          exerciseId: exercise2.id,
          order: 1,
          weight: 185.0,
        );

        await exerciseSetDao.insert(set1);
        await exerciseSetDao.insert(set2);

        final exercise1Sets = await exerciseSetDao.getAllSetsWithExerciseId(
          testExercise.id,
        );
        final exercise2Sets = await exerciseSetDao.getAllSetsWithExerciseId(
          exercise2.id,
        );

        expect(exercise1Sets.length, equals(1));
        expect(exercise2Sets.length, equals(1));
        expectExerciseSetsEqual(exercise1Sets[0], set1);
        expectExerciseSetsEqual(exercise2Sets[0], set2);
      });
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete exercise sets when exercise is deleted',
        () async {
          final exerciseSet = ExerciseSetModel.forTest(
            exerciseId: testExercise.id,
            order: 1,
            weight: 135.0,
          );
          await exerciseSetDao.insert(exerciseSet);

          // Verify exercise set exists
          expect(await exerciseSetDao.getById(exerciseSet.id), isNotNull);

          // Delete the exercise
          await exerciseDao.delete(testExercise.id);

          // Exercise set should be deleted due to CASCADE
          expect(await exerciseSetDao.getById(exerciseSet.id), isNull);
        },
      );

      test(
        'should throw exception when inserting with non-existent exercise',
        () async {
          final exerciseSet = ExerciseSetModel(
            id: 'test',
            exerciseId: 'non-existent',
            order: 1,
          );

          expect(
            () async => await exerciseSetDao.insert(exerciseSet),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
