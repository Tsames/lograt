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

  group('ExerciseSetDao Read Operations Tests', () {
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

    test('should retrieve exercise set by ID as ExerciseSetModel', () async {
      // Retrieve the exercise set we just created
      final retrieved = await exerciseSetDao.getById(existingExerciseSetId);

      // Should get back the same data we inserted
      expect(retrieved, isNotNull);
      expect(retrieved, isA<ExerciseSetModel>());
      expect(retrieved!.databaseId, equals(existingExerciseSetId));
      expect(retrieved.exerciseId, equals(testExerciseId));
      expect(retrieved.order, equals(1));
      expect(retrieved.reps, equals(10));
      expect(retrieved.weight, equals(135));
      expect(retrieved.restTimeSeconds, 60);
      expect(SetType.fromString(retrieved.setType), SetType.working);
    });

    test('should return null when exercise set does not exist', () async {
      // Try to retrieve an exercise set that definitely doesn't exist
      final nonExistentSet = await exerciseSetDao.getById(99999);

      // Should handle missing data gracefully
      expect(nonExistentSet, isNull);
    });

    test(
      'should retrieve all exercise sets for an exercise ordered correctly',
      () async {
        // Add multiple sets to the same exercise with different orders
        final set2 = ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 2,
          reps: 8,
          weight: 145,
          units: Units.pounds.name,
          setType: SetType.working.name,
        );

        final set3 = ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 3,
          reps: 6,
          weight: 155,
          units: Units.pounds.name,
          setType: SetType.working.name,
        );

        await exerciseSetDao.insert(set3);
        await exerciseSetDao.insert(set2);

        // Get all sets for the exercise
        final exerciseSets = await exerciseSetDao.getByExerciseId(
          testExerciseId,
        );

        // Should return all sets ordered by order DESC
        expect(exerciseSets.length, equals(3));
        expect(exerciseSets, everyElement(isA<ExerciseSetModel>()));

        // The ordering is 'set_order ASC', so it should be in order
        expect(exerciseSets[0].order, equals(1));
        expect(exerciseSets[0].weight, equals(135));
        expect(exerciseSets[1].order, equals(2));
        expect(exerciseSets[1].weight, equals(145));
        expect(exerciseSets[2].order, equals(3));
        expect(exerciseSets[2].weight, equals(155));
      },
    );

    test('should return empty list when exercise has no sets', () async {
      // Create a new exercise with no sets
      final newExercise = ExerciseModel(
        workoutId: testExerciseId, // Reusing IDs for simplicity
        exerciseTypeId: testExerciseId,
        order: 2,
        notes: 'Exercise with no sets',
      );
      final newExerciseId = await exerciseDao.insert(newExercise);

      // Try to get sets for the exercise with no sets
      final sets = await exerciseSetDao.getByExerciseId(newExerciseId);

      // Should return empty list, not null
      expect(sets, isEmpty);
      expect(sets, isA<List<ExerciseSetModel>>());
    });
  });
}
