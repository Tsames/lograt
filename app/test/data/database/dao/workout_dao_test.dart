import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/database/dao/workout_dao.dart';
import 'package:lograt/data/models/workout_model.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WorkoutDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutDao workoutDao;
    late WorkoutModel sampleWorkout;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();

      workoutDao = WorkoutDao(testDatabase);

      sampleWorkout = WorkoutModel('Morning Push Workout', DateTime.now());
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new workout and return a valid ID', () async {
        final insertedId = await workoutDao.insert(sampleWorkout);

        expect(insertedId, isA<int>());
        expect(insertedId, greaterThan(0));

        // Additional verification: ensure the workout was actually stored
        final retrievedWorkout = await workoutDao.getById(insertedId);
        expect(retrievedWorkout, isNotNull);
        expect(retrievedWorkout!.name, 'Morning Push Workout');
      });

      test('should handle transaction-based insert correctly', () async {
        final database = await testDatabase.database;
        late int insertedId;

        await database.transaction((txn) async {
          insertedId = await workoutDao.insertWithTransaction(
            sampleWorkout,
            txn,
          );
        });

        expect(insertedId, greaterThan(0));

        final retrieved = await workoutDao.getById(insertedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals(sampleWorkout.name));
      });
    });

    group('Read Operations', () {
      late int existingWorkoutId;

      // Set up test data that read tests can use
      setUp(() async {
        existingWorkoutId = await workoutDao.insert(sampleWorkout);
      });

      test('should retrieve workout by ID as WorkoutModel', () async {
        final retrieved = await workoutDao.getById(existingWorkoutId);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<WorkoutModel>());
        expect(retrieved!.id, equals(existingWorkoutId));
        expect(retrieved.name, equals('Morning Push Workout'));
        expect(
          retrieved.createdOn.difference(sampleWorkout.createdOn).inSeconds,
          lessThan(1),
        );
      });

      test('should return null when workout does not exist', () async {
        final nonExistentWorkout = await workoutDao.getById(99999);

        expect(nonExistentWorkout, isNull);
      });

      test('should respect limit parameter in getRecentSummaries', () async {
        for (int i = 0; i < 5; i++) {
          final workout = WorkoutModel(
            'Workout $i',
            DateTime.now().add(Duration(hours: i)),
          );
          await workoutDao.insert(workout);
        }

        final limitedResults = await workoutDao.getWorkoutSummaries(3);
        expect(limitedResults.length, equals(3));

        expect(limitedResults[0].name, equals('Workout 4')); // Most recent
        expect(limitedResults[1].name, equals('Workout 3'));
        expect(limitedResults[2].name, equals('Workout 2'));
      });

      group('Update Operations', () {
        late int existingWorkoutId;
        late WorkoutModel existingWorkout;

        setUp(() async {
          existingWorkoutId = await workoutDao.insert(sampleWorkout);
          existingWorkout = (await workoutDao.getById(existingWorkoutId))!;
        });

        test('should update existing workout successfully', () async {
          final updatedWorkout = existingWorkout.copyWith(
            name: 'Updated Morning Workout',
          );

          final rowsAffected = await workoutDao.update(updatedWorkout);

          expect(rowsAffected, equals(1));

          final retrieved = await workoutDao.getById(existingWorkoutId);
          expect(retrieved!.name, equals('Updated Morning Workout'));
          // Original timestamp should be preserved
          expect(retrieved.createdOn, equals(existingWorkout.createdOn));
        });

        test(
          'should return 0 when trying to update non-existent workout',
          () async {
            // Create a workout with an ID that doesn't exist in the database
            final nonExistentWorkout = WorkoutModel(
              id: 99999,
              'Ghost Workout',
              DateTime.now(),
            );

            final rowsAffected = await workoutDao.update(nonExistentWorkout);

            expect(rowsAffected, equals(0));
          },
        );
      });

      group('Delete Operations', () {
        late int existingWorkoutId;

        setUp(() async {
          existingWorkoutId = await workoutDao.insert(sampleWorkout);
        });

        test('should delete existing workout successfully', () async {
          final rowsDeleted = await workoutDao.delete(existingWorkoutId);

          expect(rowsDeleted, equals(1));

          final retrieved = await workoutDao.getById(existingWorkoutId);
          expect(retrieved, isNull);
        });

        test(
          'should return 0 when trying to delete non-existent workout',
          () async {
            final rowsDeleted = await workoutDao.delete(99999);

            expect(rowsDeleted, equals(0));
          },
        );

        test('should clear entire table successfully', () async {
          for (int i = 0; i < 3; i++) {
            final workout = WorkoutModel('Workout $i', DateTime.now());
            await workoutDao.insert(workout);
          }

          await workoutDao.clearTable();

          final remaining = await workoutDao.getWorkoutSummaries(10);
          expect(remaining, isEmpty);

          final original = await workoutDao.getById(existingWorkoutId);
          expect(original, isNull);
        });
      });
    });
  });
}
