import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
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
    late MuscleGroupModel testMuscleGroup3;
    late WorkoutModel testWorkout1;
    late WorkoutModel testWorkout2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToWorkoutDao = MuscleGroupToWorkoutDao(testDatabase);
      muscleGroupDao = MuscleGroupDao(testDatabase);
      workoutDao = WorkoutDao(testDatabase);

      // Create test muscle groups
      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');
      testMuscleGroup3 = MuscleGroupModel.forTest(label: 'Triceps');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);
      await muscleGroupDao.insert(testMuscleGroup3);

      // Create test workouts
      testWorkout1 = WorkoutModel.forTest(title: 'Push Day');
      testWorkout2 = WorkoutModel.forTest(title: 'Upper Body');

      await workoutDao.insert(testWorkout1);
      await workoutDao.insert(testWorkout2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a relationship correctly', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when inserting duplicate relationship',
        () async {
          await muscleGroupToWorkoutDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );

          expect(
            () async => await muscleGroupToWorkoutDao.insertRelationship(
              muscleGroupId: testMuscleGroup1.id,
              workoutId: testWorkout1.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await muscleGroupToWorkoutDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
            txn: txn,
          );

          final exists = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
            txn,
          );
          expect(exists, isTrue);
        });

        // Verify it persisted after transaction
        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        expect(exists, isTrue);
      });

      test('should allow same muscle group for different workouts', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout2.id,
        );

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout2.id,
        );

        expect(exists1, isTrue);
        expect(exists2, isTrue);
      });

      test('should allow different muscle groups for same workout', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup2.id,
          workoutId: testWorkout1.id,
        );

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup2.id,
          testWorkout1.id,
        );

        expect(exists1, isTrue);
        expect(exists2, isTrue);
      });
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple relationships correctly', () async {
        final relationships = [
          (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup3.id, workoutId: testWorkout1.id),
        ];

        await muscleGroupToWorkoutDao.batchInsertRelationships(relationships);

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup2.id,
          testWorkout1.id,
        );
        final exists3 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup3.id,
          testWorkout1.id,
        );

        expect(exists1, isTrue);
        expect(exists2, isTrue);
        expect(exists3, isTrue);
      });

      test('should handle empty list gracefully in batch insert', () async {
        await muscleGroupToWorkoutDao.batchInsertRelationships([]);

        // Should complete without error - verify no relationships exist
        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should batch insert relationships across multiple workouts',
        () async {
          final relationships = [
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout2.id),
          ];

          await muscleGroupToWorkoutDao.batchInsertRelationships(relationships);

          final workout1HasChest = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout1.id);
          final workout1HasShoulders = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup2.id, testWorkout1.id);
          final workout2HasChest = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout2.id);

          expect(workout1HasChest, isTrue);
          expect(workout1HasShoulders, isTrue);
          expect(workout2HasChest, isTrue);
        },
      );

      test(
        'should throw exception when batch insert has duplicate relationship',
        () async {
          await muscleGroupToWorkoutDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );

          final relationships = [
            (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutId: testWorkout1.id,
            ), // Duplicate
            (muscleGroupId: testMuscleGroup3.id, workoutId: testWorkout1.id),
          ];

          expect(
            () async => await muscleGroupToWorkoutDao.batchInsertRelationships(
              relationships,
            ),
            throwsA(isA<DatabaseException>()),
          );

          // Verify rollback - only the original relationship exists
          final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
          );
          final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup2.id,
            testWorkout1.id,
          );
          final exists3 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup3.id,
            testWorkout1.id,
          );

          expect(exists1, isTrue); // Original remains
          expect(exists2, isFalse); // Not inserted
          expect(exists3, isFalse); // Not inserted
        },
      );
    });

    group('Read Operations', () {
      test('should return true when relationship exists', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );

        expect(exists, isTrue);
      });

      test('should return false when relationship does not exist', () async {
        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );

        expect(exists, isFalse);
      });

      test(
        'should correctly distinguish between different relationships',
        () async {
          await muscleGroupToWorkoutDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );

          final existsCorrect = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout1.id);
          final existsWrongWorkout = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout2.id);
          final existsWrongMuscleGroup = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup2.id, testWorkout1.id);

          expect(existsCorrect, isTrue);
          expect(existsWrongWorkout, isFalse);
          expect(existsWrongMuscleGroup, isFalse);
        },
      );
    });

    group('Delete Operations', () {
      test('should delete existing relationship successfully', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        await muscleGroupToWorkoutDao.delete(
          testMuscleGroup1.id,
          testWorkout1.id,
        );

        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should throw exception when trying to delete non-existent relationship',
        () async {
          expect(
            () async => await muscleGroupToWorkoutDao.delete(
              testMuscleGroup1.id,
              testWorkout1.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should only delete the specific relationship', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup2.id,
          workoutId: testWorkout1.id,
        );

        await muscleGroupToWorkoutDao.delete(
          testMuscleGroup1.id,
          testWorkout1.id,
        );

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup2.id,
          testWorkout1.id,
        );

        expect(exists1, isFalse);
        expect(exists2, isTrue); // Other relationship unchanged
      });
    });

    group('Bulk Delete Operations', () {
      test('should delete multiple muscle groups for a workout', () async {
        await muscleGroupToWorkoutDao.batchInsertRelationships([
          (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup3.id, workoutId: testWorkout1.id),
        ]);

        final deletedCount = await muscleGroupToWorkoutDao
            .deleteMuscleGroupsForWorkout(
              testWorkout1.id,
              muscleGroupIds: [testMuscleGroup1.id, testMuscleGroup2.id],
            );

        expect(deletedCount, equals(2));

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup2.id,
          testWorkout1.id,
        );
        final exists3 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup3.id,
          testWorkout1.id,
        );

        expect(exists1, isFalse);
        expect(exists2, isFalse);
        expect(exists3, isTrue); // Not in delete list
      });

      test('should return 0 when deleting with empty list', () async {
        await muscleGroupToWorkoutDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutId: testWorkout1.id,
        );

        final deletedCount = await muscleGroupToWorkoutDao
            .deleteMuscleGroupsForWorkout(testWorkout1.id, muscleGroupIds: []);

        expect(deletedCount, equals(0));

        // Original relationship still exists
        final exists = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when no matching relationships exist',
        () async {
          await muscleGroupToWorkoutDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutId: testWorkout1.id,
          );

          expect(
            () async =>
                await muscleGroupToWorkoutDao.deleteMuscleGroupsForWorkout(
                  testWorkout1.id,
                  muscleGroupIds: [testMuscleGroup2.id, testMuscleGroup3.id],
                ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified workout',
        () async {
          await muscleGroupToWorkoutDao.batchInsertRelationships([
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout2.id),
          ]);

          final deletedCount = await muscleGroupToWorkoutDao
              .deleteMuscleGroupsForWorkout(
                testWorkout1.id,
                muscleGroupIds: [testMuscleGroup1.id],
              );

          expect(deletedCount, equals(1));

          final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
          );
          final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout2.id,
          );

          expect(exists1, isFalse);
          expect(exists2, isTrue); // Different workout unchanged
        },
      );

      test(
        'should throw exception when at least one relationship does not exist and rollback deletions.',
        () async {
          await muscleGroupToWorkoutDao.batchInsertRelationships([
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
          ]);

          // Try to delete 3 muscle groups, but only 2 exist
          expect(
            () async =>
                await muscleGroupToWorkoutDao.deleteMuscleGroupsForWorkout(
                  testWorkout1.id,
                  muscleGroupIds: [
                    testMuscleGroup1.id,
                    testMuscleGroup2.id,
                    testMuscleGroup3.id,
                  ],
                ),
            throwsA(isA<Exception>()),
          );

          final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
          );
          final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup2.id,
            testWorkout1.id,
          );

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );
    });

    group('Delete All Muscle Groups for Workout', () {
      test('should delete all muscle groups for a workout', () async {
        await muscleGroupToWorkoutDao.batchInsertRelationships([
          (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
          (muscleGroupId: testMuscleGroup3.id, workoutId: testWorkout1.id),
        ]);

        final deletedCount = await muscleGroupToWorkoutDao
            .deleteMuscleGroupsForWorkout(testWorkout1.id);

        expect(deletedCount, equals(3));

        final exists1 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkout1.id,
        );
        final exists2 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup2.id,
          testWorkout1.id,
        );
        final exists3 = await muscleGroupToWorkoutDao.relationshipExists(
          testMuscleGroup3.id,
          testWorkout1.id,
        );

        expect(exists1, isFalse);
        expect(exists2, isFalse);
        expect(exists3, isFalse);
      });

      test(
        'should throw exception when deleting all for workout with no relationships',
        () async {
          expect(
            () async => await muscleGroupToWorkoutDao
                .deleteMuscleGroupsForWorkout(testWorkout1.id),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified workout when deleting all',
        () async {
          await muscleGroupToWorkoutDao.batchInsertRelationships([
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout2.id),
          ]);

          final deletedCount = await muscleGroupToWorkoutDao
              .deleteMuscleGroupsForWorkout(testWorkout1.id);

          expect(deletedCount, equals(2));

          final workout1Exists1 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout1.id);
          final workout1Exists2 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup2.id, testWorkout1.id);
          final workout2Exists = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout2.id);

          expect(workout1Exists1, isFalse);
          expect(workout1Exists2, isFalse);
          expect(workout2Exists, isTrue); // Different workout unchanged
        },
      );
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when workout is deleted',
        () async {
          await muscleGroupToWorkoutDao.batchInsertRelationships([
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup2.id, workoutId: testWorkout1.id),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout1.id);
          final beforeDelete2 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup2.id, testWorkout1.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the workout
          await workoutDao.delete(testWorkout1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
          );
          final afterDelete2 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup2.id,
            testWorkout1.id,
          );
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          await muscleGroupToWorkoutDao.batchInsertRelationships([
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout1.id),
            (muscleGroupId: testMuscleGroup1.id, workoutId: testWorkout2.id),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout1.id);
          final beforeDelete2 = await muscleGroupToWorkoutDao
              .relationshipExists(testMuscleGroup1.id, testWorkout2.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout1.id,
          );
          final afterDelete2 = await muscleGroupToWorkoutDao.relationshipExists(
            testMuscleGroup1.id,
            testWorkout2.id,
          );
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
