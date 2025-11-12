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

  group('ExerciseSetDao Update Operations Tests', () {
    late AppDatabase testDatabase;
    late ExerciseSetDao exerciseSetDao;
    late ExerciseDao exerciseDao;
    late ExerciseTypeDao exerciseTypeDao;
    late WorkoutDao workoutDao;
    late int testExerciseId;

    late int existingExerciseSetId;
    late ExerciseSetModel existingExerciseSet;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseSetDao = ExerciseSetDao(testDatabase);
      exerciseDao = ExerciseDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);

      // Create prerequisite data that exercise sets depend on
      final testWorkout = WorkoutModel('Test Workout', DateTime.now());
      final testWorkoutId = await workoutDao.insert(testWorkout);

      final testExerciseType = ExerciseTypeModel(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      final testExerciseTypeId = await exerciseTypeDao.insert(testExerciseType);

      final testExercise = ExerciseModel(
        workoutId: testWorkoutId,
        exerciseTypeId: testExerciseTypeId,
        order: 1,
        notes: 'Test exercise for sets',
      );
      testExerciseId = await exerciseDao.insert(testExercise);

      // Create sample exercise set data
      final sampleExerciseSet = ExerciseSetModel(
        exerciseId: testExerciseId,
        order: 1,
        reps: 10,
        weight: 135,
        units: Units.pounds.name,
        restTimeSeconds: 60,
        setType: SetType.working.name,
        notes: "New PR!",
      );

      existingExerciseSetId = await exerciseSetDao.insert(sampleExerciseSet);
      existingExerciseSet = (await exerciseSetDao.getById(
        existingExerciseSetId,
      ))!;
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should update existing exercise set successfully', () async {
      // Modify the exercise set data
      final updatedExerciseSet = existingExerciseSet.copyWith(
        reps: 12,
        weight: 145,
        restTimeSeconds: 90,
        setType: SetType.failure.name,
      );

      // Update the exercise set in the database
      final rowIsUpdated = await exerciseSetDao.update(updatedExerciseSet);

      // Should indicate one row was updated
      expect(rowIsUpdated, equals(true));

      // Verify the changes were actually saved
      final retrieved = await exerciseSetDao.getById(existingExerciseSetId);
      expect(retrieved!.reps, equals(12));
      expect(retrieved.weight, equals(145));
      expect(retrieved.restTimeSeconds, 90);
      expect(SetType.fromString(retrieved.setType), SetType.failure);

      // Verify unchanged fields remain the same
      expect(retrieved.exerciseId, equals(existingExerciseSet.exerciseId));
      expect(retrieved.order, equals(existingExerciseSet.order));
    });

    test(
      'should return false when trying to update non-existent exercise set',
      () async {
        // Create an exercise set with an ID that doesn't exist
        final nonExistentExerciseSet = ExerciseSetModel(
          databaseId: 99999,
          exerciseId: testExerciseId,
          order: 1,
          reps: 10,
          weight: 135,
          units: Units.pounds.name,
          setType: SetType.working.name,
        );

        // Try to update the non-existent exercise set
        final rowIsUpdated = await exerciseSetDao.update(
          nonExistentExerciseSet,
        );

        // Should indicate no rows were affected
        expect(rowIsUpdated, equals(false));
      },
    );

    test(
      'should throw ArgumentError when trying to update exercise set without ID',
      () async {
        // Create an exercise set without an ID
        final setWithoutId = ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 1,
          reps: 10,
          weight: 135,
          units: Units.pounds.name,
          setType: SetType.working.name,
        );

        // Should throw ArgumentError
        expect(
          () async => await exerciseSetDao.update(setWithoutId),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
