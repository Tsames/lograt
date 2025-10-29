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

  group('ExerciseSetDao Tests', () {
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

    group('Insert Operations', () {
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
          await exerciseSetDao.batchInsertWithTransaction(sets: sets, txn: txn);
        });

        // All sets should be inserted correctly
        final allSets = await exerciseSetDao.getByExerciseId(testExerciseId);
        expect(allSets.length, equals(3));

        // Verify each set was inserted correctly
        expect(
          allSets.any((set) => set.reps == 12 && set.weight == 135),
          isTrue,
        );
        expect(
          allSets.any((set) => set.reps == 10 && set.weight == 145),
          isTrue,
        );
        expect(
          allSets.any((set) => set.reps == 8 && set.weight == 155),
          isTrue,
        );
      });

      test('should handle empty batch insert gracefully', () async {
        // Empty list of sets
        final emptySets = <ExerciseSetModel>[];

        // Try to batch insert empty list
        final database = await testDatabase.database;
        await database.transaction((txn) async {
          await exerciseSetDao.batchInsertWithTransaction(
            sets: emptySets,
            txn: txn,
          );
        });

        // Should complete without error
        final allSets = await exerciseSetDao.getByExerciseId(testExerciseId);
        expect(allSets, isEmpty);
      });
    });

    group('Read Operations', () {
      late int existingExerciseSetId;

      setUp(() async {
        existingExerciseSetId = await exerciseSetDao.insert(sampleExerciseSet);
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

      test('should batch retrieve sets for multiple exercises', () async {
        // Create another exercise and add sets to both exercises
        final exercise2 = ExerciseModel(
          workoutId: testExerciseId, // Reusing for simplicity
          exerciseTypeId: testExerciseId,
          order: 2,
          notes: 'Second exercise',
        );
        final exercise2Id = await exerciseDao.insert(exercise2);

        // Add sets to the second exercise
        await exerciseSetDao.insert(
          ExerciseSetModel(
            exerciseId: exercise2Id,
            order: 1,
            reps: 15,
            weight: 65,
            units: Units.pounds.name,
            setType: SetType.working.name,
          ),
        );

        await exerciseSetDao.insert(
          ExerciseSetModel(
            exerciseId: exercise2Id,
            order: 2,
            reps: 12,
            weight: 75,
            units: Units.pounds.name,
            setType: SetType.working.name,
          ),
        );

        // Batch retrieve sets for both exercises
        final batchSets = await exerciseSetDao.getBatchByExerciseIds([
          testExerciseId,
          exercise2Id,
        ]);

        // Should return sets from both exercises
        expect(
          batchSets.length,
          equals(3),
        ); // 1 from first exercise + 2 from second
        expect(batchSets, everyElement(isA<ExerciseSetModel>()));

        // Verify we have sets from both exercises
        final exercise1Sets = batchSets.where(
          (set) => set.exerciseId == testExerciseId,
        );
        final exercise2Sets = batchSets.where(
          (set) => set.exerciseId == exercise2Id,
        );

        expect(exercise1Sets.length, equals(1));
        expect(exercise2Sets.length, equals(2));
      });

      test(
        'should return empty list when batch retrieving with empty exercise ID list',
        () async {
          // Try to batch retrieve with empty list
          final batchSets = await exerciseSetDao.getBatchByExerciseIds([]);

          // Should return empty list immediately
          expect(batchSets, isEmpty);
          expect(batchSets, isA<List<ExerciseSetModel>>());
        },
      );

      test(
        'should return empty list when batch retrieving for exercises with no sets',
        () async {
          // Create exercises with no sets
          final exercise2 = ExerciseModel(
            workoutId: testExerciseId,
            exerciseTypeId: testExerciseId,
            order: 2,
            notes: 'Empty exercise',
          );
          final exercise2Id = await exerciseDao.insert(exercise2);

          // Batch retrieve for exercises that have no sets
          final batchSets = await exerciseSetDao.getBatchByExerciseIds([
            exercise2Id,
            99999,
          ]);

          // Should return empty list
          expect(batchSets, isEmpty);
        },
      );
    });

    group('Update Operations', () {
      late int existingExerciseSetId;
      late ExerciseSetModel existingExerciseSet;

      setUp(() async {
        existingExerciseSetId = await exerciseSetDao.insert(sampleExerciseSet);
        existingExerciseSet = (await exerciseSetDao.getById(
          existingExerciseSetId,
        ))!;
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
        final rowsAffected = await exerciseSetDao.update(updatedExerciseSet);

        // Should indicate one row was updated
        expect(rowsAffected, equals(1));

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
        'should return 0 when trying to update non-existent exercise set',
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
          final rowsAffected = await exerciseSetDao.update(
            nonExistentExerciseSet,
          );

          // Should indicate no rows were affected
          expect(rowsAffected, equals(0));
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

    group('Delete Operations', () {
      late int existingExerciseSetId;

      setUp(() async {
        existingExerciseSetId = await exerciseSetDao.insert(sampleExerciseSet);
      });

      test('should delete existing exercise set successfully', () async {
        // Delete the exercise set
        final rowsDeleted = await exerciseSetDao.delete(existingExerciseSetId);

        // Should indicate one row was deleted
        expect(rowsDeleted, equals(1));

        // Verify the exercise set no longer exists
        final retrieved = await exerciseSetDao.getById(existingExerciseSetId);
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent exercise set',
        () async {
          // Try to delete an exercise set that doesn't exist
          final rowsDeleted = await exerciseSetDao.delete(99999);

          // Should indicate no rows were affected
          expect(rowsDeleted, equals(0));
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
  });
}
