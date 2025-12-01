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

  group('ExerciseSetDao Read Operations Tests', () {
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

    test('should retrieve exercise set by ID correctly', () async {
      // Retrieve the exercise set we just created
      final retrieved = await exerciseSetDao.getById(testExerciseSet.id);

      // Should get back the same data we inserted
      expect(retrieved, isNotNull);
      expect(retrieved!.exerciseId, equals(testExercise.id));
      expect(retrieved.order, equals(1));
      expect(
        retrieved.setType != null
            ? SetType.fromString(retrieved.setType!)
            : null,
        SetType.working,
      );
      expect(retrieved.weight, equals(135));
      expect(
        retrieved.units != null ? Units.fromString(retrieved.units!) : null,
        Units.pounds,
      );
      expect(retrieved.reps, equals(10));
      expect(retrieved.restTimeSeconds, 60);
    });

    test('should return null when exercise set does not exist', () async {
      // Try to retrieve an exercise set that definitely doesn't exist
      final nonExistentSet = await exerciseSetDao.getById('99999');

      // Should handle missing data gracefully
      expect(nonExistentSet, isNull);
    });

    test(
      'should retrieve all exercise sets for an exercise ordered correctly',
      () async {
        // Add multiple sets to the same exercise with different orders
        final set2 = ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 2,
          setType: SetType.working.name,
          weight: 145,
          units: Units.pounds.name,
          reps: 8,
        );

        final set3 = ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 3,
          setType: SetType.working.name,
          weight: 155,
          units: Units.pounds.name,
          reps: 6,
        );

        await exerciseSetDao.insert(set3);
        await exerciseSetDao.insert(set2);

        // Get all sets for the exercise
        final exerciseSets = await exerciseSetDao.getByExerciseId(
          testExercise.id,
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
      final newExercise = ExerciseModel.forTest(
        workoutId: testExercise.id,
        order: 2,
        exerciseTypeId: testExercise.id,
        notes: 'Exercise with no sets',
      );

      await exerciseDao.insert(newExercise);

      // Try to get sets for the exercise with no sets
      final sets = await exerciseSetDao.getByExerciseId(newExercise.id);

      // Should return empty list, not null
      expect(sets, isEmpty);
      expect(sets, isA<List<ExerciseSetModel>>());
    });
  });
}
