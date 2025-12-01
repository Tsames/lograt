import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/exercise_dao.dart';
import 'package:lograt/data/dao/exercise_set_dao.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
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

  group('ExerciseSetDao Update Operations Tests', () {
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

    test('should update existing exercise set successfully', () async {
      // Modify the exercise set data
      final updatedExerciseSet = testExerciseSet.copyWith(
        setType: SetType.failure.name,
        weight: 145,
        reps: 12,
        restTimeSeconds: 90,
      );

      // Update the exercise set in the database
      final rowIsUpdated = await exerciseSetDao.update(updatedExerciseSet);

      // Should indicate one row was updated
      expect(rowIsUpdated, equals(true));

      // Verify the changes were actually saved
      final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
      expect(retrieved!.reps, equals(12));
      expect(retrieved.weight, equals(145));
      expect(retrieved.restTimeSeconds, 90);
      expect(
        retrieved.setType != null
            ? SetType.fromString(retrieved.setType!)
            : null,
        SetType.failure,
      );

      // Verify unchanged fields remain the same
      expect(retrieved.exerciseId, equals(testExerciseSet.exerciseId));
      expect(retrieved.order, equals(testExerciseSet.order));
    });

    test(
      'should return false when trying to update non-existent exercise set',
      () async {
        // Create an exercise set with an ID that doesn't exist
        final nonExistentExerciseSet = ExerciseSetModel(
          id: '99999',
          order: 1,
          exerciseId: testExercise.id,
          setType: SetType.working.name,
          weight: 135,
          units: Units.pounds.name,
          reps: 10,
        );

        // Try to update the non-existent exercise set
        final rowIsUpdated = await exerciseSetDao.update(
          nonExistentExerciseSet,
        );

        // Should indicate no rows were affected
        expect(rowIsUpdated, equals(false));
      },
    );
  });
}
