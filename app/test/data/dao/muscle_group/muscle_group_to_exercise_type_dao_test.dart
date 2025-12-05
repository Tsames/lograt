import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_exercise_type_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('MuscleGroupToExerciseTypeDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupToExerciseTypeDao muscleGroupToExerciseTypeDao;
    late MuscleGroupDao muscleGroupDao;
    late ExerciseTypeDao exerciseTypeDao;

    late MuscleGroupModel testMuscleGroup1;
    late MuscleGroupModel testMuscleGroup2;
    late MuscleGroupModel testMuscleGroup3;
    late ExerciseTypeModel testExerciseType1;
    late ExerciseTypeModel testExerciseType2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToExerciseTypeDao = MuscleGroupToExerciseTypeDao(testDatabase);
      muscleGroupDao = MuscleGroupDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      // Create test muscle groups
      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');
      testMuscleGroup3 = MuscleGroupModel.forTest(label: 'Triceps');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);
      await muscleGroupDao.insert(testMuscleGroup3);

      // Create test exercise types
      testExerciseType1 = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      testExerciseType2 = ExerciseTypeModel.forTest(
        name: 'Overhead Press',
        description: 'Shoulder exercise',
      );

      await exerciseTypeDao.insert(testExerciseType1);
      await exerciseTypeDao.insert(testExerciseType2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a relationship correctly', () async {
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          exerciseTypeId: testExerciseType1.id,
        );

        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when inserting duplicate relationship',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          expect(
            () async => await muscleGroupToExerciseTypeDao.insertRelationship(
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
            txn: txn,
          );

          final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
            txn,
          );
          expect(exists, isTrue);
        });

        // Verify it persisted after transaction
        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should allow same muscle group for different exercise types',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType2.id,
          );

          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType2.id,
          );

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );

      test(
        'should allow different muscle groups for same exercise type',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup2.id,
            exerciseTypeId: testExerciseType1.id,
          );

          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup2.id,
            testExerciseType1.id,
          );

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
            exerciseTypeId: testExerciseType1.id,
          ),
          (
            muscleGroupId: testMuscleGroup2.id,
            exerciseTypeId: testExerciseType1.id,
          ),
          (
            muscleGroupId: testMuscleGroup3.id,
            exerciseTypeId: testExerciseType1.id,
          ),
        ];

        await muscleGroupToExerciseTypeDao.batchInsertRelationships(
          relationships,
        );

        final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup2.id,
          testExerciseType1.id,
        );
        final exists3 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup3.id,
          testExerciseType1.id,
        );

        expect(exists1, isTrue);
        expect(exists2, isTrue);
        expect(exists3, isTrue);
      });

      test('should handle empty list gracefully in batch insert', () async {
        await muscleGroupToExerciseTypeDao.batchInsertRelationships([]);

        // Should complete without error - verify no relationships exist
        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should batch insert relationships across multiple exercise types',
        () async {
          final relationships = [
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType2.id,
            ),
          ];

          await muscleGroupToExerciseTypeDao.batchInsertRelationships(
            relationships,
          );

          final type1HasChest = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final type1HasShoulders = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup2.id, testExerciseType1.id);
          final type2HasChest = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType2.id);

          expect(type1HasChest, isTrue);
          expect(type1HasShoulders, isTrue);
          expect(type2HasChest, isTrue);
        },
      );

      test(
        'should throw exception when batch insert has duplicate relationship',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          final relationships = [
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ), // Duplicate
            (
              muscleGroupId: testMuscleGroup3.id,
              exerciseTypeId: testExerciseType1.id,
            ),
          ];

          expect(
            () async => await muscleGroupToExerciseTypeDao
                .batchInsertRelationships(relationships),
            throwsA(isA<DatabaseException>()),
          );

          // Verify rollback - only the original relationship exists
          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup2.id,
            testExerciseType1.id,
          );
          final exists3 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup3.id,
            testExerciseType1.id,
          );

          expect(exists1, isTrue); // Original remains
          expect(exists2, isFalse); // Not inserted
          expect(exists3, isFalse); // Not inserted
        },
      );
    });

    group('Read Operations', () {
      test('should return true when relationship exists', () async {
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          exerciseTypeId: testExerciseType1.id,
        );

        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );

        expect(exists, isTrue);
      });

      test('should return false when relationship does not exist', () async {
        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );

        expect(exists, isFalse);
      });

      test(
        'should correctly distinguish between different relationships',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          final existsCorrect = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final existsWrongType = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType2.id);
          final existsWrongMuscleGroup = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup2.id, testExerciseType1.id);

          expect(existsCorrect, isTrue);
          expect(existsWrongType, isFalse);
          expect(existsWrongMuscleGroup, isFalse);
        },
      );
    });

    group('Delete Operations', () {
      test('should delete existing relationship successfully', () async {
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          exerciseTypeId: testExerciseType1.id,
        );

        await muscleGroupToExerciseTypeDao.delete(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );

        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        expect(exists, isFalse);
      });

      test(
        'should throw exception when trying to delete non-existent relationship',
        () async {
          expect(
            () async => await muscleGroupToExerciseTypeDao.delete(
              testMuscleGroup1.id,
              testExerciseType1.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should only delete the specific relationship', () async {
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          exerciseTypeId: testExerciseType1.id,
        );
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup2.id,
          exerciseTypeId: testExerciseType1.id,
        );

        await muscleGroupToExerciseTypeDao.delete(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );

        final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup2.id,
          testExerciseType1.id,
        );

        expect(exists1, isFalse);
        expect(exists2, isTrue); // Other relationship unchanged
      });
    });

    group('Bulk Delete Operations', () {
      test(
        'should delete multiple muscle groups for an exercise type',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup3.id,
              exerciseTypeId: testExerciseType1.id,
            ),
          ]);

          final deletedCount = await muscleGroupToExerciseTypeDao
              .deleteMuscleGroupsForExerciseType(
                testExerciseType1.id,
                muscleGroupIds: [testMuscleGroup1.id, testMuscleGroup2.id],
              );

          expect(deletedCount, equals(2));

          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup2.id,
            testExerciseType1.id,
          );
          final exists3 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup3.id,
            testExerciseType1.id,
          );

          expect(exists1, isFalse);
          expect(exists2, isFalse);
          expect(exists3, isTrue); // Not in delete list
        },
      );

      test('should return 0 when deleting with empty list', () async {
        await muscleGroupToExerciseTypeDao.insertRelationship(
          muscleGroupId: testMuscleGroup1.id,
          exerciseTypeId: testExerciseType1.id,
        );

        final deletedCount = await muscleGroupToExerciseTypeDao
            .deleteMuscleGroupsForExerciseType(
              testExerciseType1.id,
              muscleGroupIds: [],
            );

        expect(deletedCount, equals(0));

        // Original relationship still exists
        final exists = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        expect(exists, isTrue);
      });

      test(
        'should throw exception when no matching relationships exist',
        () async {
          await muscleGroupToExerciseTypeDao.insertRelationship(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );

          expect(
            () async => await muscleGroupToExerciseTypeDao
                .deleteMuscleGroupsForExerciseType(
                  testExerciseType1.id,
                  muscleGroupIds: [testMuscleGroup2.id, testMuscleGroup3.id],
                ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified exercise type',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType2.id,
            ),
          ]);

          final deletedCount = await muscleGroupToExerciseTypeDao
              .deleteMuscleGroupsForExerciseType(
                testExerciseType1.id,
                muscleGroupIds: [testMuscleGroup1.id],
              );

          expect(deletedCount, equals(1));

          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType2.id,
          );

          expect(exists1, isFalse);
          expect(exists2, isTrue); // Different exercise type unchanged
        },
      );

      test(
        'should throw exception when at least one relationship does not exist and rollback deletions',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
          ]);

          // Try to delete 3 muscle groups, but only 2 exist
          expect(
            () async => await muscleGroupToExerciseTypeDao
                .deleteMuscleGroupsForExerciseType(
                  testExerciseType1.id,
                  muscleGroupIds: [
                    testMuscleGroup1.id,
                    testMuscleGroup2.id,
                    testMuscleGroup3.id,
                  ],
                ),
            throwsA(isA<Exception>()),
          );

          final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup1.id,
            testExerciseType1.id,
          );
          final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
            testMuscleGroup2.id,
            testExerciseType1.id,
          );

          expect(exists1, isTrue);
          expect(exists2, isTrue);
        },
      );
    });

    group('Delete All Muscle Groups for Exercise Type', () {
      test('should delete all muscle groups for an exercise type', () async {
        await muscleGroupToExerciseTypeDao.batchInsertRelationships([
          (
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          ),
          (
            muscleGroupId: testMuscleGroup2.id,
            exerciseTypeId: testExerciseType1.id,
          ),
          (
            muscleGroupId: testMuscleGroup3.id,
            exerciseTypeId: testExerciseType1.id,
          ),
        ]);

        final deletedCount = await muscleGroupToExerciseTypeDao
            .deleteMuscleGroupsForExerciseType(testExerciseType1.id);

        expect(deletedCount, equals(3));

        final exists1 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup1.id,
          testExerciseType1.id,
        );
        final exists2 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup2.id,
          testExerciseType1.id,
        );
        final exists3 = await muscleGroupToExerciseTypeDao.relationshipExists(
          testMuscleGroup3.id,
          testExerciseType1.id,
        );

        expect(exists1, isFalse);
        expect(exists2, isFalse);
        expect(exists3, isFalse);
      });

      test(
        'should throw exception when deleting all for exercise type with no relationships',
        () async {
          expect(
            () async => await muscleGroupToExerciseTypeDao
                .deleteMuscleGroupsForExerciseType(testExerciseType1.id),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'should only delete relationships for the specified exercise type when deleting all',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType2.id,
            ),
          ]);

          final deletedCount = await muscleGroupToExerciseTypeDao
              .deleteMuscleGroupsForExerciseType(testExerciseType1.id);

          expect(deletedCount, equals(2));

          final type1Exists1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final type1Exists2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup2.id, testExerciseType1.id);
          final type2Exists = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType2.id);

          expect(type1Exists1, isFalse);
          expect(type1Exists2, isFalse);
          expect(type2Exists, isTrue); // Different exercise type unchanged
        },
      );
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when exercise type is deleted',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup2.id,
              exerciseTypeId: testExerciseType1.id,
            ),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final beforeDelete2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup2.id, testExerciseType1.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the exercise type
          await exerciseTypeDao.delete(testExerciseType1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final afterDelete2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup2.id, testExerciseType1.id);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType1.id,
            ),
            (
              muscleGroupId: testMuscleGroup1.id,
              exerciseTypeId: testExerciseType2.id,
            ),
          ]);

          // Verify relationships exist
          final beforeDelete1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final beforeDelete2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType2.id);
          expect(beforeDelete1, isTrue);
          expect(beforeDelete2, isTrue);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Relationships should be automatically deleted due to CASCADE
          final afterDelete1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType1.id);
          final afterDelete2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(testMuscleGroup1.id, testExerciseType2.id);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
