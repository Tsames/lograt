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

  group('ExerciseSetDao Insert Operations Tests', () {
    late AppDatabase testDatabase;
    late ExerciseSetDao exerciseSetDao;
    late ExerciseDao exerciseDao;
    late ExerciseTypeDao exerciseTypeDao;
    late WorkoutDao workoutDao;
    late ExerciseSetModel sampleExerciseSet;
    late int testExerciseId;

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
      sampleExerciseSet = ExerciseSetModel(
        exerciseId: testExerciseId,
        order: 1,
        reps: 10,
        weight: 135,
        units: Units.pounds.name,
        restTimeSeconds: 60,
        setType: SetType.working.name,
        notes: "New PR!",
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should insert a new exercise set and return a valid ID', () async {
      // Insert the exercise set into the database
      final insertedId = await exerciseSetDao.insert(sampleExerciseSet);

      // Verify the operation succeeded and returned a meaningful ID
      expect(insertedId, isA<int>());
      expect(insertedId, greaterThan(0));

      // Additional verification: ensure the exercise set was actually stored
      final retrieved = await exerciseSetDao.getById(insertedId);
      expect(retrieved, isNotNull);
      expect(retrieved!.exerciseId, equals(testExerciseId));
      expect(retrieved.order, equals(1));
      expect(retrieved.reps, equals(10));
      expect(retrieved.weight, equals(135));
      expect(Units.fromString(retrieved.units), Units.pounds);
      expect(retrieved.restTimeSeconds, 60);
      expect(SetType.fromString(retrieved.setType), SetType.working);
      expect(retrieved.notes, "New PR!");
    });

    test('should handle batch insert with transaction correctly', () async {
      // Create multiple sets for batch insertion
      final sets = [
        ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 1,
          reps: 12,
          weight: 135,
          units: Units.pounds.name,
          setType: SetType.working.name,
        ),
        ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 2,
          reps: 10,
          weight: 145,
          units: Units.pounds.name,
          setType: SetType.working.name,
        ),
        ExerciseSetModel(
          exerciseId: testExerciseId,
          order: 3,
          reps: 8,
          weight: 155,
          units: Units.pounds.name,
          setType: SetType.working.name,
        ),
      ];

      // Use the batch insert with transaction
      final database = await testDatabase.database;
      await database.transaction((txn) async {
        await exerciseSetDao.batchInsert(sets, txn);
      });

      // All sets should be inserted correctly
      final allSets = await exerciseSetDao.getByExerciseId(testExerciseId);
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
      final allSets = await exerciseSetDao.getByExerciseId(testExerciseId);
      expect(allSets, isEmpty);
    });
  });
}
