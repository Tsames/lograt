import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('MuscleGroupToWorkoutDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupToWorkoutDao muscleGroupToWorkoutDao;
    late MuscleGroupDao muscleGroupDao;
    late WorkoutDao workoutDao;

    late MuscleGroupModel testMuscleGroup1;
    late MuscleGroupModel testMuscleGroup2;
    late WorkoutModel testWorkout1;
    late WorkoutModel testWorkout2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToWorkoutDao = MuscleGroupToWorkoutDao(testDatabase);
      muscleGroupDao = MuscleGroupDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);

      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);

      testWorkout1 = WorkoutModel.forTest(title: 'Push Day');
      testWorkout2 = WorkoutModel.forTest(title: 'Upper Body');

      await workoutDao.insert(testWorkout1);
      await workoutDao.insert(testWorkout2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getRelationshipsByWorkoutIds', () {
      test('should retrieve relationships for specified workout ids', () async {
        final relationship1 = MuscleGroupToWorkoutModel.createWithId(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );
        final relationship2 = MuscleGroupToWorkoutModel.createWithId(
          muscleGroupId: testMuscleGroup2.id,
          workoutId: testWorkout1.id,
        );
        final relationship3 = MuscleGroupToWorkoutModel.createWithId(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout2.id,
        );

        await muscleGroupToWorkoutDao.batchInsertRelationships([
          relationship1,
          relationship2,
          relationship3,
        ]);

        final retrieved = await muscleGroupToWorkoutDao
            .getRelationshipsByWorkoutIds([testWorkout1.id]);

        expect(retrieved.length, equals(2));
        expect(retrieved.every((r) => r.workoutId == testWorkout1.id), isTrue);
      });

      test(
        'should retrieve relationships across multiple workout ids',
        () async {
          final relationship1 = MuscleGroupToWorkoutModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );
          final relationship2 = MuscleGroupToWorkoutModel.createWithId(
            muscleGroupId: testMuscleGroup2.id,
            workoutId: testWorkout2.id,
          );

          await muscleGroupToWorkoutDao.batchInsertRelationships([
            relationship1,
            relationship2,
          ]);

          final retrieved = await muscleGroupToWorkoutDao
              .getRelationshipsByWorkoutIds([testWorkout1.id, testWorkout2.id]);

          expect(retrieved.length, equals(2));
        },
      );

      test(
        'should return empty list when no relationships exist for workout ids',
        () async {
          final retrieved = await muscleGroupToWorkoutDao
              .getRelationshipsByWorkoutIds([testWorkout1.id]);

          expect(retrieved, isEmpty);
        },
      );

      test('should throw exception when given empty list', () async {
        expect(
          () async =>
              await muscleGroupToWorkoutDao.getRelationshipsByWorkoutIds([]),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when workout is deleted',
        () async {
          final relationship = MuscleGroupToWorkoutModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );
          await muscleGroupToWorkoutDao.insertRelationship(relationship);

          // Verify relationship exists
          final beforeDelete = await muscleGroupToWorkoutDao.relationshipExists(
            relationship,
          );
          expect(beforeDelete, isTrue);

          // Delete the workout
          await workoutDao.delete(testWorkout1.id);

          // Relationship should be automatically deleted due to CASCADE
          final afterDelete = await muscleGroupToWorkoutDao.relationshipExists(
            relationship,
          );
          expect(afterDelete, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          final relationship1 = MuscleGroupToWorkoutModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );
          final relationship2 = MuscleGroupToWorkoutModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout2.id,
          );

          await muscleGroupToWorkoutDao.batchInsertRelationships([
            relationship1,
            relationship2,
          ]);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Both relationships should be deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutDao.relationshipExists(
            relationship1,
          );
          final afterDelete2 = await muscleGroupToWorkoutDao.relationshipExists(
            relationship2,
          );
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
