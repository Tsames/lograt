import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/exercise_dao.dart';
import 'package:lograt/data/dao/exercise_set_dao.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/data/models/exercise_model.dart';
import 'package:lograt/data/models/exercise_set_model.dart';
import 'package:lograt/data/models/exercise_type_model.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('ExerciseSetDao Delete Operations Tests', () {
    late AppDatabase testDatabase;
    late ExerciseSetDao exerciseSetDao;
    late ExerciseDao exerciseDao;
    late ExerciseTypeDao exerciseTypeDao;
    late WorkoutDao workoutDao;

    late WorkoutModel testWorkout;
    late ExerciseTypeModel testExerciseType;
    late ExerciseModel testExercise;
    late ExerciseSetModel testExerciseSet;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseSetDao = ExerciseSetDao(testDatabase);
      exerciseDao = ExerciseDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);

      // Create prerequisite data that exercise sets depend on
      testWorkout = WorkoutModel.forTest(title: 'Test Workout');
      await workoutDao.insert(testWorkout);

      testExerciseType = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      await exerciseTypeDao.insert(testExerciseType);

      testExercise = ExerciseModel.forTest(
        workoutId: testWorkout.id,
        order: 1,
        exerciseTypeId: testExerciseType.id,
        notes: 'Test exercise for sets',
      );
      await exerciseDao.insert(testExercise);

      testExerciseSet = ExerciseSetModel.forTest(
        exerciseId: testExercise.id,
        order: 1,
        setType: SetType.working.name,
        weight: 135,
        units: Units.pounds.name,
        reps: 10,
        restTimeSeconds: 60,
      );
      await exerciseSetDao.insert(testExerciseSet);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should delete existing exercise set successfully', () async {
      // Delete the exercise set
      final setIsDeleted = await exerciseSetDao.delete(testExerciseSet.id);

      // Should indicate one row was deleted
      expect(setIsDeleted, equals(true));

      // Verify the exercise set no longer exists
      final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
      expect(retrieved, isNull);
    });

    test(
      'should return false when trying to delete non-existent exercise set',
      () async {
        // Try to delete an exercise set that doesn't exist
        final setIsDeleted = await exerciseSetDao.delete("99999");

        // Should indicate no rows were affected
        expect(setIsDeleted, equals(false));
      },
    );

    test('should delete all exercise sets for a specific exercise', () async {
      // Add multiple sets to the exercise
      await exerciseSetDao.insert(
        ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 2,
          setType: SetType.working.name,
          weight: 145,
          units: Units.pounds.name,
          reps: 8,
        ),
      );

      await exerciseSetDao.insert(
        ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 3,
          setType: SetType.working.name,
          weight: 155,
          units: Units.pounds.name,
          reps: 6,
        ),
      );

      // Verify we have sets before deletion
      final beforeSets = await exerciseSetDao.getByExerciseId(testExercise.id);
      expect(beforeSets.length, equals(3));

      // Delete all sets for the exercise
      final rowsDeleted = await exerciseSetDao.deleteByExerciseId(
        testExercise.id,
      );

      // Should delete all sets for the exercise
      expect(rowsDeleted, equals(3));

      // Verify no sets remain for this exercise
      final afterSets = await exerciseSetDao.getByExerciseId(testExercise.id);
      expect(afterSets, isEmpty);
    });

    test(
      'should return 0 when trying to delete sets from exercise with no sets',
      () async {
        // Create a new exercise with no sets
        final newExercise = ExerciseModel.forTest(
          workoutId: testWorkout.id,
          order: 2,
          exerciseTypeId: testExercise.id,
          notes: 'Exercise with no sets',
        );

        await exerciseDao.insert(newExercise);

        // Try to delete sets from the exercise with no sets
        final rowsDeleted = await exerciseSetDao.deleteByExerciseId(
          newExercise.id,
        );

        // Should indicate no rows were affected
        expect(rowsDeleted, equals(0));
      },
    );
  });
}
