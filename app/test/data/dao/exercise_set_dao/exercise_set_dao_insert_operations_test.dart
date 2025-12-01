import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/workout/exercise_dao.dart';
import 'package:lograt/data/dao/workout/exercise_set_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
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

  group('ExerciseSetDao Insert Operations Tests', () {
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
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should insert a new exercise set correctly', () async {
      // Insert the exercise set into the database
      await exerciseSetDao.insert(testExerciseSet);

      // Verify the operation succeeded
      final retrieved = await exerciseSetDao.getById(testExerciseSet.id);
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

    test('should handle batch insert with transaction correctly', () async {
      // Create multiple sets for batch insertion
      final sets = [
        ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 1,
          setType: SetType.working.name,
          weight: 135,
          units: Units.pounds.name,
          reps: 12,
        ),
        ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 2,
          setType: SetType.working.name,
          weight: 145,
          units: Units.pounds.name,
          reps: 10,
        ),
        ExerciseSetModel.forTest(
          exerciseId: testExercise.id,
          order: 3,
          setType: SetType.working.name,
          weight: 155,
          units: Units.pounds.name,
          reps: 8,
        ),
      ];

      // Use the batch insert with transaction
      final database = await testDatabase.database;
      await database.transaction((txn) async {
        await exerciseSetDao.batchInsert(sets, txn);
      });

      // All sets should be inserted correctly
      final allSets = await exerciseSetDao.getByExerciseId(testExercise.id);
      expect(allSets.length, equals(3));

      // Verify each set was inserted correctly
      expect(allSets.any((set) => set.reps == 12 && set.weight == 135), isTrue);
      expect(allSets.any((set) => set.reps == 10 && set.weight == 145), isTrue);
      expect(allSets.any((set) => set.reps == 8 && set.weight == 155), isTrue);
    });

    test('should handle empty batch insert gracefully', () async {
      // Empty list of sets
      final emptySets = <ExerciseSetModel>[];

      // Try to batch insert empty list
      final database = await testDatabase.database;
      await database.transaction((txn) async {
        await exerciseSetDao.batchInsert(emptySets, txn);
      });

      // Should complete without error
      final allSets = await exerciseSetDao.getByExerciseId(testExercise.id);
      expect(allSets, isEmpty);
    });
  });
}
