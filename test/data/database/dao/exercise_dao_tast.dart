import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/database/dao/exercise_dao.dart';
import 'package:lograt/data/database/dao/exercise_type_dao.dart';
import 'package:lograt/data/database/dao/workout_dao.dart';
import 'package:lograt/data/models/exercise_model.dart';
import 'package:lograt/data/models/exercise_type_model.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:lograt/domain/entities/exercise.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lograt/data/database/app_database.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('ExerciseDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseDao exerciseDao;
    late ExerciseTypeDao exerciseTypeDao;
    late WorkoutDao workoutDao;
    late ExerciseModel sampleExercise;
    late int testWorkoutId;
    late int testExerciseTypeId;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseDao = ExerciseDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);

      // Create prerequisite data that exercises depend on
      final testWorkout = WorkoutModel(name: 'Test Workout', createdOn: DateTime.now());
      testWorkoutId = await workoutDao.insert(testWorkout);

      final testExerciseType = ExerciseTypeModel(name: 'Bench Press', description: 'Chest exercise');
      testExerciseTypeId = await exerciseTypeDao.insert(testExerciseType);

      // Create sample exercise data
      sampleExercise = ExerciseModel(
        workoutId: testWorkoutId,
        exerciseTypeId: testExerciseTypeId,
        order: 1,
        notes: 'New PR today!',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new exercise and return a valid ID', () async {
        final insertedId = await exerciseDao.insert(sampleExercise);

        expect(insertedId, isA<int>());
        expect(insertedId, greaterThan(0));

        final retrieved = await exerciseDao.getById(insertedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.workoutId, equals(testWorkoutId));
        expect(retrieved.exerciseTypeId, equals(testExerciseTypeId));
        expect(retrieved.order, equals(1));
        expect(retrieved.notes, equals('New PR today!'));
      });

      test('should handle transaction-based insert correctly', () async {
        final database = await testDatabase.database;
        late int insertedId;

        await database.transaction((txn) async {
          insertedId = await exerciseDao.insertWithTransaction(exercise: sampleExercise, txn: txn);
        });

        expect(insertedId, greaterThan(0));

        final retrieved = await exerciseDao.getById(insertedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.workoutId, equals(sampleExercise.workoutId));
      });
    });

    group('Read Operations', () {
      late int existingExerciseId;

      setUp(() async {
        existingExerciseId = await exerciseDao.insert(sampleExercise);
      });

      test('should retrieve exercise by ID as ExerciseModel', () async {
        final retrieved = await exerciseDao.getById(existingExerciseId);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<ExerciseModel>());
        expect(retrieved!.id, equals(existingExerciseId));
        expect(retrieved.workoutId, equals(testWorkoutId));
        expect(retrieved.exerciseTypeId, equals(testExerciseTypeId));
        expect(retrieved.order, equals(1));
        expect(retrieved.notes, equals('New PR today!'));
      });

      test('should return null when exercise does not exist', () async {
        final nonExistentExercise = await exerciseDao.getById(99999);

        expect(nonExistentExercise, isNull);
      });

      test('should retrieve all exercises for a workout ordered by sequence', () async {
        // Add multiple exercises to the same workout in an out of sequence order
        final exercise2 = ExerciseModel(
          workoutId: testWorkoutId,
          exerciseTypeId: testExerciseTypeId,
          order: 3,
          notes: 'Third exercise',
        );

        final exercise3 = ExerciseModel(
          workoutId: testWorkoutId,
          exerciseTypeId: testExerciseTypeId,
          order: 2,
          notes: 'Second exercise',
        );

        await exerciseDao.insert(exercise2);
        await exerciseDao.insert(exercise3);

        final workoutExercises = await exerciseDao.getByWorkoutId(testWorkoutId);

        expect(workoutExercises.length, equals(3));
        expect(workoutExercises, everyElement(isA<ExerciseModel>()));

        // Verify correct ordering despite out of order insertion
        expect(workoutExercises[0].order, equals(1));
        expect(workoutExercises[0].notes, equals('New PR today!'));
        expect(workoutExercises[1].order, equals(2));
        expect(workoutExercises[1].notes, equals('Second exercise'));
        expect(workoutExercises[2].order, equals(3));
        expect(workoutExercises[2].notes, equals('Third exercise'));
      });

      test('should return empty list when workout has no exercises', () async {
        // Create a new workout with no exercises
        final emptyWorkout = WorkoutModel(name: 'Empty Workout', createdOn: DateTime.now());
        final emptyWorkoutId = await workoutDao.insert(emptyWorkout);

        final exercises = await exerciseDao.getByWorkoutId(emptyWorkoutId);

        // Should return empty list, not null
        expect(exercises, isNotNull);
        expect(exercises, isA<List<ExerciseModel>>());
        expect(exercises, isEmpty);
      });

      test('should retrieve exercises with types by workout id', () async {
        // Create additional exercise type and exercise to test the JOIN
        final squatType = ExerciseTypeModel(name: 'Squat', description: 'Leg exercise');
        final squatTypeId = await exerciseTypeDao.insert(squatType);

        final squatExercise = ExerciseModel(
          workoutId: testWorkoutId,
          exerciseTypeId: squatTypeId,
          order: 2,
          notes: 'Remember proper form',
        );
        await exerciseDao.insert(squatExercise);

        // Get exercises with their type information
        final exercisesWithTypes = await exerciseDao.getExercisesWithTypesByWorkoutId(testWorkoutId);

        // Should return Exercise domain entities with complete type information
        expect(exercisesWithTypes.length, equals(2));
        expect(exercisesWithTypes, everyElement(isA<Exercise>()));

        // Verify the first exercise (Bench Press)
        expect(exercisesWithTypes[0].exerciseType.name, equals('Bench Press'));
        expect(exercisesWithTypes[0].exerciseType.description, equals('Chest exercise'));
        expect(exercisesWithTypes[0].order, equals(1));
        expect(exercisesWithTypes[0].notes, equals('New PR today!'));
        expect(exercisesWithTypes[0].sets, isEmpty); // Should have no sets as documented

        // Verify the second exercise (Squat)
        expect(exercisesWithTypes[1].exerciseType.name, equals('Squat'));
        expect(exercisesWithTypes[1].exerciseType.description, equals('Leg exercise'));
        expect(exercisesWithTypes[1].order, equals(2));
        expect(exercisesWithTypes[1].notes, equals('Remember proper form'));
        expect(exercisesWithTypes[1].sets, isEmpty);
      });

      test('should return empty list when JOIN query finds no exercises', () async {
        // Create a workout with no exercises
        final emptyWorkout = WorkoutModel(name: 'Empty Workout', createdOn: DateTime.now());
        final emptyWorkoutId = await workoutDao.insert(emptyWorkout);

        // Try the JOIN query on the empty workout
        final exercisesWithTypes = await exerciseDao.getExercisesWithTypesByWorkoutId(emptyWorkoutId);

        // Should return empty list
        expect(exercisesWithTypes, isEmpty);
        expect(exercisesWithTypes, isA<List<Exercise>>());
      });

      test('should retrieve exercises by exercise type with limit', () async {
        // Create multiple workouts with the same exercise type
        final workout2 = WorkoutModel(name: 'Workout 2', createdOn: DateTime.now());
        final workout2Id = await workoutDao.insert(workout2);

        final workout3 = WorkoutModel(name: 'Workout 3', createdOn: DateTime.now());
        final workout3Id = await workoutDao.insert(workout3);

        // Add bench press exercises to different workouts
        await exerciseDao.insert(
          ExerciseModel(
            workoutId: workout2Id,
            exerciseTypeId: testExerciseTypeId,
            order: 1,
            notes: 'Bench press in workout 2',
          ),
        );

        await exerciseDao.insert(
          ExerciseModel(
            workoutId: workout3Id,
            exerciseTypeId: testExerciseTypeId,
            order: 1,
            notes: 'Bench press in workout 3',
          ),
        );

        // Get exercises by type with a limit
        final typeExercises = await exerciseDao.getByExerciseTypeId(exerciseTypeId: testExerciseTypeId, limit: 2);

        // Should return limited results ordered by most recent workout
        expect(typeExercises.length, equals(2));
        expect(typeExercises, everyElement(isA<ExerciseModel>()));

        // Should be ordered by workout_id DESC (most recent first)
        expect(typeExercises[0].workoutId, greaterThan(typeExercises[1].workoutId));

        // All should use the same exercise type
        expect(typeExercises.every((ex) => ex.exerciseTypeId == testExerciseTypeId), isTrue);
      });

      test('should return correct count of exercises in a workout', () async {
        // Add multiple exercises to the workout
        await exerciseDao.insert(
          ExerciseModel(
            workoutId: testWorkoutId,
            exerciseTypeId: testExerciseTypeId,
            order: 2,
            notes: 'Second exercise',
          ),
        );

        await exerciseDao.insert(
          ExerciseModel(
            workoutId: testWorkoutId,
            exerciseTypeId: testExerciseTypeId,
            order: 3,
            notes: 'Third exercise',
          ),
        );

        final count = await exerciseDao.getCountByWorkoutId(testWorkoutId);

        // Should return the correct number
        expect(count, equals(3)); // Original exercise + 2 new ones
        expect(count, isA<int>());
      });

      test('should return 0 count for workout with no exercises', () async {
        // Create a new empty workout
        final emptyWorkout = WorkoutModel(name: 'Empty Workout', createdOn: DateTime.now());
        final emptyWorkoutId = await workoutDao.insert(emptyWorkout);

        final count = await exerciseDao.getCountByWorkoutId(emptyWorkoutId);

        // Should return 0
        expect(count, equals(0));
      });
    });

    group('Update Operations', () {
      late int existingExerciseId;
      late ExerciseModel existingExercise;

      setUp(() async {
        existingExerciseId = await exerciseDao.insert(sampleExercise);
        existingExercise = (await exerciseDao.getById(existingExerciseId))!;
      });

      test('should update existing exercise successfully', () async {
        // Modify the exercise data
        final updatedExercise = existingExercise.copyWith(order: 5, notes: 'Updated notes for the exercise');

        final rowsAffected = await exerciseDao.update(updatedExercise);

        expect(rowsAffected, equals(1));

        // Verify the changes were actually saved
        final retrieved = await exerciseDao.getById(existingExerciseId);
        expect(retrieved!.order, equals(5));
        expect(retrieved.notes, equals('Updated notes for the exercise'));

        // Verify unchanged fields remain the same
        expect(retrieved.workoutId, equals(existingExercise.workoutId));
        expect(retrieved.exerciseTypeId, equals(existingExercise.exerciseTypeId));
      });

      test('should return 0 when trying to update non-existent exercise', () async {
        // Create an exercise with an ID that doesn't exist
        final nonExistentExercise = ExerciseModel(
          id: 99999,
          workoutId: testWorkoutId,
          exerciseTypeId: testExerciseTypeId,
          order: 1,
          notes: 'This exercise does not exist',
        );

        final rowsAffected = await exerciseDao.update(nonExistentExercise);

        // Should indicate no rows were affected
        expect(rowsAffected, equals(0));
      });

      test('should throw ArgumentError when trying to update exercise without ID', () async {
        // Create an exercise without an ID
        final exerciseWithoutId = ExerciseModel(
          workoutId: testWorkoutId,
          exerciseTypeId: testExerciseTypeId,
          order: 1,
          notes: 'Exercise without ID',
        );

        // Should throw ArgumentError
        expect(() async => await exerciseDao.update(exerciseWithoutId), throwsA(isA<ArgumentError>()));
      });
    });

    group('Delete Operations', () {
      late int existingExerciseId;

      setUp(() async {
        existingExerciseId = await exerciseDao.insert(sampleExercise);
      });

      test('should delete existing exercise successfully', () async {
        // Delete the exercise
        final rowsDeleted = await exerciseDao.delete(existingExerciseId);

        expect(rowsDeleted, equals(1));

        // Verify the exercise no longer exists
        final retrieved = await exerciseDao.getById(existingExerciseId);
        expect(retrieved, isNull);
      });

      test('should return 0 when trying to delete non-existent exercise', () async {
        // Try to delete an exercise that doesn't exist
        final rowsDeleted = await exerciseDao.delete(99999);

        // Should indicate no rows were affected (the method checks existence first)
        expect(rowsDeleted, equals(0));
      });

      test('should delete all exercises for a specific workout', () async {
        // Add multiple exercises to the workout
        await exerciseDao.insert(
          ExerciseModel(
            workoutId: testWorkoutId,
            exerciseTypeId: testExerciseTypeId,
            order: 2,
            notes: 'Second exercise',
          ),
        );

        await exerciseDao.insert(
          ExerciseModel(
            workoutId: testWorkoutId,
            exerciseTypeId: testExerciseTypeId,
            order: 3,
            notes: 'Third exercise',
          ),
        );

        // Verify we have exercises before deletion
        final beforeCount = await exerciseDao.getCountByWorkoutId(testWorkoutId);
        expect(beforeCount, equals(3));

        // Delete all exercises for the workout
        final rowsDeleted = await exerciseDao.deleteByWorkoutId(testWorkoutId);

        // Should delete all exercises for the workout
        expect(rowsDeleted, equals(3));

        // Verify no exercises remain for this workout
        final afterCount = await exerciseDao.getCountByWorkoutId(testWorkoutId);
        expect(afterCount, equals(0));

        final remainingExercises = await exerciseDao.getByWorkoutId(testWorkoutId);
        expect(remainingExercises, isEmpty);
      });

      test('should return 0 when trying to delete exercises from workout with no exercises', () async {
        // Create a new empty workout
        final emptyWorkout = WorkoutModel(name: 'Empty Workout', createdOn: DateTime.now());
        final emptyWorkoutId = await workoutDao.insert(emptyWorkout);

        // Try to delete exercises from the empty workout
        final rowsDeleted = await exerciseDao.deleteByWorkoutId(emptyWorkoutId);

        // Should indicate no rows were affected
        expect(rowsDeleted, equals(0));
      });
    });
  });
}
