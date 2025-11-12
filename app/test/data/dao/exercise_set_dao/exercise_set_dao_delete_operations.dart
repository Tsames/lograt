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
    late int testExerciseId;

    late int existingExerciseSetId;

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
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should delete existing exercise set successfully', () async {
      // Delete the exercise set
      final setIsDeleted = await exerciseSetDao.delete(existingExerciseSetId);

      // Should indicate one row was deleted
      expect(setIsDeleted, equals(true));

      // Verify the exercise set no longer exists
      final retrieved = await exerciseSetDao.getById(existingExerciseSetId);
      expect(retrieved, isNull);
    });

    test(
      'should return false when trying to delete non-existent exercise set',
      () async {
        // Try to delete an exercise set that doesn't exist
        final setIsDeleted = await exerciseSetDao.delete(99999);

        // Should indicate no rows were affected
        expect(setIsDeleted, equals(false));
      },
    );

    test('should delete all exercise sets for a specific exercise', () async {
      // Add multiple sets to the exercise
      await exerciseSetDao.insert(
        ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 2,
          reps: 8,
          weight: 145,
          units: Units.pounds.name,
          setType: SetType.working.name,
        ),
      );

      await exerciseSetDao.insert(
        ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 3,
          reps: 6,
          weight: 155,
          units: Units.pounds.name,
          setType: SetType.working.name,
        ),
      );

      // Verify we have sets before deletion
      final beforeSets = await exerciseSetDao.getByExerciseId(testExerciseId);
      expect(beforeSets.length, equals(3));

      // Delete all sets for the exercise
      final rowsDeleted = await exerciseSetDao.deleteByExerciseId(
        testExerciseId,
      );

      // Should delete all sets for the exercise
      expect(rowsDeleted, equals(3));

      // Verify no sets remain for this exercise
      final afterSets = await exerciseSetDao.getByExerciseId(testExerciseId);
      expect(afterSets, isEmpty);
    });

    test(
      'should return 0 when trying to delete sets from exercise with no sets',
      () async {
        // Create a new exercise with no sets
        final newExercise = ExerciseModel(
          workoutId: testExerciseId,
          exerciseTypeId: testExerciseId,
          order: 2,
          notes: 'Exercise with no sets',
        );
        final newExerciseId = await exerciseDao.insert(newExercise);

        // Try to delete sets from the exercise with no sets
        final rowsDeleted = await exerciseSetDao.deleteByExerciseId(
          newExerciseId,
        );

        // Should indicate no rows were affected
        expect(rowsDeleted, equals(0));
      },
    );
  });
}
