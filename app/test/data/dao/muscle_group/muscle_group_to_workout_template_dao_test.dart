import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_template_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('MuscleGroupToWorkoutTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupToWorkoutTemplateDao muscleGroupToWorkoutTemplateDao;
    late MuscleGroupDao muscleGroupDao;
    late WorkoutTemplateDao workoutTemplateDao;

    late MuscleGroupModel testMuscleGroup1;
    late MuscleGroupModel testMuscleGroup2;
    late MuscleGroupModel testMuscleGroup3;
    late WorkoutTemplateModel testWorkoutTemplate1;
    late WorkoutTemplateModel testWorkoutTemplate2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToWorkoutTemplateDao = MuscleGroupToWorkoutTemplateDao(
        testDatabase,
      );
      muscleGroupDao = MuscleGroupDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      // Create test muscle groups
      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');
      testMuscleGroup3 = MuscleGroupModel.forTest(label: 'Triceps');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);
      await muscleGroupDao.insert(testMuscleGroup3);

      // Create test workout templates
      testWorkoutTemplate1 = WorkoutTemplateModel.forTest(
        title: 'Push Day Template',
      );
      testWorkoutTemplate2 = WorkoutTemplateModel.forTest(
        title: 'Upper Body Template',
      );

      await workoutTemplateDao.insert(testWorkoutTemplate1);
      await workoutTemplateDao.insert(testWorkoutTemplate2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a relationship correctly', () async {
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );

        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when inserting duplicate relationship',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          expect(
            () async =>
                await muscleGroupToWorkoutTemplateDao.insertRelationship(
                  muscleGroupId: testMuscleGroup1.id,
                  workoutTemplateId: testWorkoutTemplate1.id,
                ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
            txn: txn,
          );

          final exists = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(
                testMuscleGroup1.id,
                testWorkoutTemplate1.id,
                txn,
              );
          expect(exists, isTrue);
        });

        // Verify it persisted after transaction
        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should allow same muscle group for different workout templates',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate2.id,
          );

          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );

      test(
        'should allow different muscle groups for same workout template',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup2.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple relationships correctly', () async {
        final relationships = [
          (
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
          (
            muscleGroupId: testMuscleGroup2.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
          (
            muscleGroupId: testMuscleGroup3.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
        ];

        await muscleGroupToWorkoutTemplateDao.batchInsertRelationships(
          relationships,
        );

        final exists1 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
        final exists2 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
        final exists3 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup3.id, testWorkoutTemplate1.id);

        expect(exists1, isTrue);
        expect(exists2, isTrue);
        expect(exists3, isTrue);
      });

      test('should handle empty list gracefully in batch insert', () async {
        await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([]);

        // Should complete without error - verify no relationships exist
        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should batch insert relationships across multiple workout templates',
        () async {
          final relationships = [
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate2.id,
            ),
          ];

          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships(
            relationships,
          );

          final template1HasChest = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final template1HasShoulders = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          final template2HasChest = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);

          expect(template1HasChest, isTrue);
          expect(template1HasShoulders, isTrue);
          expect(template2HasChest, isTrue);
        },
      );

      test(
        'should throw exception when batch insert has duplicate relationship',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          final relationships = [
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ), // Duplicate
            (
              muscleGroupId: testMuscleGroup3.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
          ];

          expect(
            () async => await muscleGroupToWorkoutTemplateDao
                .batchInsertRelationships(relationships),
            throwsA(isA<DatabaseException>()),
          );

          // Verify rollback - only the original relationship exists
          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          final exists3 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup3.id, testWorkoutTemplate1.id);

          expect(exists1, isTrue); // Original remains
          expect(exists2, isFalse); // Not inserted
          expect(exists3, isFalse); // Not inserted
        },
      );
    });

    group('Read Operations', () {
      test('should return true when relationship exists', () async {
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );

        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );

        expect(exists, isTrue);
      });

      test('should return false when relationship does not exist', () async {
        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );

        expect(exists, isFalse);
      });

      test(
        'should correctly distinguish between different relationships',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          final existsCorrect = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final existsWrongTemplate = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);
          final existsWrongMuscleGroup = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);

          expect(existsCorrect, isTrue);
          expect(existsWrongTemplate, isFalse);
          expect(existsWrongMuscleGroup, isFalse);
        },
      );
    });

    group('Delete Operations', () {
      test('should delete existing relationship successfully', () async {
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );

        await muscleGroupToWorkoutTemplateDao.delete(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );

        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should throw exception when trying to delete non-existent relationship',
        () async {
          expect(
            () async => await muscleGroupToWorkoutTemplateDao.delete(
              testMuscleGroup1.id,
              testWorkoutTemplate1.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should only delete the specific relationship', () async {
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup2.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );

        await muscleGroupToWorkoutTemplateDao.delete(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );

        final exists1 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
        final exists2 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);

        expect(exists1, isFalse);
        expect(exists2, isTrue); // Other relationship unchanged
      });
    });

    group('Bulk Delete Operations', () {
      test(
        'should delete multiple muscle groups for a workout template',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup3.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
          ]);

          final deletedCount = await muscleGroupToWorkoutTemplateDao
              .deleteMuscleGroupsForWorkoutTemplate(
                testWorkoutTemplate1.id,
                muscleGroupIds: [testMuscleGroup1.id, testMuscleGroup2.id],
              );

          expect(deletedCount, equals(2));

          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          final exists3 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup3.id, testWorkoutTemplate1.id);

          expect(exists1, isFalse);
          expect(exists2, isFalse);
          expect(exists3, isTrue); // Not in delete list
        },
      );

      test('should return 0 when deleting with empty list', () async {
        await muscleGroupToWorkoutTemplateDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          workoutTemplateId: testWorkoutTemplate1.id,
        );

        final deletedCount = await muscleGroupToWorkoutTemplateDao
            .deleteMuscleGroupsForWorkoutTemplate(
              testWorkoutTemplate1.id,
              muscleGroupIds: [],
            );

        expect(deletedCount, equals(0));

        // Original relationship still exists
        final exists = await muscleGroupToWorkoutTemplateDao.relationshipExists(
          testMuscleGroup1.id,
          testWorkoutTemplate1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when no matching relationships exist',
        () async {
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );

          expect(
            () async => await muscleGroupToWorkoutTemplateDao
                .deleteMuscleGroupsForWorkoutTemplate(
                  testWorkoutTemplate1.id,
                  muscleGroupIds: [testMuscleGroup2.id, testMuscleGroup3.id],
                ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified workout template',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate2.id,
            ),
          ]);

          final deletedCount = await muscleGroupToWorkoutTemplateDao
              .deleteMuscleGroupsForWorkoutTemplate(
                testWorkoutTemplate1.id,
                muscleGroupIds: [testMuscleGroup1.id],
              );

          expect(deletedCount, equals(1));

          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);

          expect(exists1, isFalse);
          expect(exists2, isTrue); // Different template unchanged
        },
      );

      test(
        'should throw exception when at least one relationship does not exist and rollback deletions',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
          ]);

          // Try to delete 3 muscle groups, but only 2 exist
          expect(
            () async => await muscleGroupToWorkoutTemplateDao
                .deleteMuscleGroupsForWorkoutTemplate(
                  testWorkoutTemplate1.id,
                  muscleGroupIds: [
                    testMuscleGroup1.id,
                    testMuscleGroup2.id,
                    testMuscleGroup3.id,
                  ],
                ),
            throwsA(isA<Exception>()),
          );

          final exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );
    });

    group('Delete All Muscle Groups for Workout Template', () {
      test('should delete all muscle groups for a workout template', () async {
        await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
          (
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
          (
            muscleGroupId: testMuscleGroup2.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
          (
            muscleGroupId: testMuscleGroup3.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          ),
        ]);

        final deletedCount = await muscleGroupToWorkoutTemplateDao
            .deleteMuscleGroupsForWorkoutTemplate(testWorkoutTemplate1.id);

        expect(deletedCount, equals(3));

        final exists1 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
        final exists2 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
        final exists3 = await muscleGroupToWorkoutTemplateDao
            .relationshipExists(testMuscleGroup3.id, testWorkoutTemplate1.id);

        expect(exists1, isFalse);
        expect(exists2, isFalse);
        expect(exists3, isFalse);
      });

      test(
        'should throw exception when deleting all for template with no relationships',
        () async {
          expect(
            () async => await muscleGroupToWorkoutTemplateDao
                .deleteMuscleGroupsForWorkoutTemplate(testWorkoutTemplate1.id),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified template when deleting all',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate2.id,
            ),
          ]);

          final deletedCount = await muscleGroupToWorkoutTemplateDao
              .deleteMuscleGroupsForWorkoutTemplate(testWorkoutTemplate1.id);

          expect(deletedCount, equals(2));

          final template1Exists1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final template1Exists2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          final template2Exists = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);

          expect(template1Exists1, isFalse);
          expect(template1Exists2, isFalse);
          expect(template2Exists, isTrue); // Different template unchanged
        },
      );
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when workout template is deleted',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final beforeDelete2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the workout template
          await workoutTemplateDao.delete(testWorkoutTemplate1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final afterDelete2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup2.id, testWorkoutTemplate1.id);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              workoutTemplateId: testWorkoutTemplate2.id,
            ),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final beforeDelete2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate1.id);
          final afterDelete2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(testMuscleGroup1.id, testWorkoutTemplate2.id);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
