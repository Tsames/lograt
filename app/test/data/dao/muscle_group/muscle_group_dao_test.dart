import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectMuscleGroupsEqual(
    MuscleGroupModel? actual,
    MuscleGroupModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected muscle group to exist but got null',
    );

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    for (final field in MuscleGroupFields.values) {
      expect(
        actualMap[field],
        equals(expectedMap[field]),
        reason: 'Field "$field" does not match',
      );
    }
  }

  group('MuscleGroupDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupDao muscleGroupDao;
    late MuscleGroupModel testMuscleGroup;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupDao = MuscleGroupDao(testDatabase);

      testMuscleGroup = MuscleGroupModel.forTest(
        label: 'Chest',
        description: 'Pectoral muscles',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new muscle group correctly', () async {
        await muscleGroupDao.insert(testMuscleGroup);

        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test('should handle inserting muscle group with minimal data', () async {
        final minimalMuscleGroup = MuscleGroupModel.forTest(label: 'Back');

        await muscleGroupDao.insert(minimalMuscleGroup);

        final retrieved = await muscleGroupDao.getById(minimalMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, minimalMuscleGroup);
      });

      test(
        'should throw exception when inserting muscle group with duplicate id',
        () async {
          final otherMuscleGroup = testMuscleGroup.copyWith(
            label: 'Different Label',
          );
          await muscleGroupDao.insert(testMuscleGroup);
          expect(
            () async => await muscleGroupDao.insert(otherMuscleGroup),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await muscleGroupDao.insert(testMuscleGroup, txn);
          final retrieved = await muscleGroupDao.getById(
            testMuscleGroup.id,
            txn,
          );
          expectMuscleGroupsEqual(retrieved, testMuscleGroup);
        });

        // Verify it persisted after transaction
        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple muscle groups correctly', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Chest', description: 'Pectorals'),
          MuscleGroupModel.forTest(label: 'Back', description: 'Latissimus'),
          MuscleGroupModel.forTest(label: 'Legs', description: 'Quadriceps'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        final allMuscleGroups = await muscleGroupDao
            .getAllMuscleGroupsPaginated();
        expect(allMuscleGroups.length, equals(3));
        expect(allMuscleGroups, everyElement(isA<MuscleGroupModel>()));

        // Verify they're sorted by label (ASC)
        expect(allMuscleGroups[0].label, equals('Back'));
        expect(allMuscleGroups[1].label, equals('Chest'));
        expect(allMuscleGroups[2].label, equals('Legs'));
      });

      test('should handle empty list gracefully in batch insert', () async {
        await muscleGroupDao.batchInsert([]);

        final allMuscleGroups = await muscleGroupDao
            .getAllMuscleGroupsPaginated();
        expect(allMuscleGroups, isEmpty);
      });

      test(
        'should throw exception and rollback insertions when batch insert has duplicate id among valid muscle groups',
        () async {
          await muscleGroupDao.insert(testMuscleGroup);

          final muscleGroups = [
            MuscleGroupModel.forTest(label: 'Back'),
            testMuscleGroup,
            MuscleGroupModel.forTest(label: 'Legs'),
          ];

          expect(
            () async => await muscleGroupDao.batchInsert(muscleGroups),
            throwsA(isA<DatabaseException>()),
          );

          final allMuscleGroups = await muscleGroupDao
              .getAllMuscleGroupsPaginated();
          expect(allMuscleGroups.length, equals(1));
          expectMuscleGroupsEqual(allMuscleGroups.first, testMuscleGroup);
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should retrieve muscle group by id correctly', () async {
        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);

        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test('should return null when muscle group does not exist', () async {
        final nonExistent = await muscleGroupDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve muscle group by label correctly', () async {
        final retrieved = await muscleGroupDao.getByName('Chest');

        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test(
        'should return null when muscle group with label does not exist',
        () async {
          final nonExistent = await muscleGroupDao.getByName(
            'Non-existent Muscle Group',
          );

          expect(nonExistent, isNull);
        },
      );

      test('should retrieve all muscle groups ordered by label', () async {
        final back = MuscleGroupModel.forTest(
          label: 'Back',
          description: 'Latissimus',
        );
        final legs = MuscleGroupModel.forTest(
          label: 'Legs',
          description: 'Quadriceps',
        );

        await muscleGroupDao.insert(back);
        await muscleGroupDao.insert(legs);

        final allMuscleGroups = await muscleGroupDao
            .getAllMuscleGroupsPaginated();

        expect(allMuscleGroups.length, equals(3));
        expect(allMuscleGroups, everyElement(isA<MuscleGroupModel>()));

        // Verify alphabetical ordering
        expect(allMuscleGroups[0].label, equals('Back'));
        expect(allMuscleGroups[1].label, equals('Chest'));
        expect(allMuscleGroups[2].label, equals('Legs'));
      });

      test('should return empty list when no muscle groups exist', () async {
        await muscleGroupDao.delete(testMuscleGroup.id);

        final muscleGroups = await muscleGroupDao.getAllMuscleGroupsPaginated();

        expect(muscleGroups, isEmpty);
        expect(muscleGroups, isA<List<MuscleGroupModel>>());
      });

      test('should respect pagination limit and offset', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Abdominals'),
          MuscleGroupModel.forTest(label: 'Biceps'),
          MuscleGroupModel.forTest(label: 'Deltoids'),
          MuscleGroupModel.forTest(label: 'Glutes'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        // Get first 2
        final page1 = await muscleGroupDao.getAllMuscleGroupsPaginated(
          limit: 2,
          offset: 0,
        );
        expect(page1.length, equals(2));
        expect(page1[0].label, equals('Abdominals'));
        expect(page1[1].label, equals('Biceps'));

        // Get next 2
        final page2 = await muscleGroupDao.getAllMuscleGroupsPaginated(
          limit: 2,
          offset: 2,
        );
        expect(page2.length, equals(2));
        expect(page2[0].label, equals('Chest'));
        expect(page2[1].label, equals('Deltoids'));
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should update existing muscle group successfully', () async {
        final updatedMuscleGroup = testMuscleGroup.copyWith(
          label: 'Pectorals',
          description: 'Chest muscles',
        );

        await muscleGroupDao.update(updatedMuscleGroup);

        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, updatedMuscleGroup);
      });

      test(
        'should throw an exception when trying to update non-existent muscle group',
        () async {
          final nonExistentMuscleGroup = MuscleGroupModel(
            id: '99999',
            label: 'Non-existent',
          );

          expect(
            () async => await muscleGroupDao.update(nonExistentMuscleGroup),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Batch Update Operations', () {
      test('should batch update multiple muscle groups correctly', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Chest', description: 'Original 1'),
          MuscleGroupModel.forTest(label: 'Back', description: 'Original 2'),
          MuscleGroupModel.forTest(label: 'Legs', description: 'Original 3'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        final updatedMuscleGroups = [
          muscleGroups[0].copyWith(description: 'Updated 1'),
          muscleGroups[1].copyWith(description: 'Updated 2'),
          muscleGroups[2].copyWith(description: 'Updated 3'),
        ];

        await muscleGroupDao.batchUpdate(updatedMuscleGroups);

        final retrieved1 = await muscleGroupDao.getById(muscleGroups[0].id);
        final retrieved2 = await muscleGroupDao.getById(muscleGroups[1].id);
        final retrieved3 = await muscleGroupDao.getById(muscleGroups[2].id);

        expectMuscleGroupsEqual(retrieved1, updatedMuscleGroups[0]);
        expectMuscleGroupsEqual(retrieved2, updatedMuscleGroups[1]);
        expectMuscleGroupsEqual(retrieved3, updatedMuscleGroups[2]);
      });

      test('should handle empty list gracefully in batch update', () async {
        await muscleGroupDao.insert(testMuscleGroup);

        await muscleGroupDao.batchUpdate([]);

        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test(
        'should throw exception and rollback all updates when one muscle group does not exist',
        () async {
          final existingMuscleGroup = MuscleGroupModel.forTest(
            label: 'Chest',
            description: 'Original',
          );
          await muscleGroupDao.insert(existingMuscleGroup);

          final nonExistentMuscleGroup = MuscleGroupModel(
            id: 'non-existent',
            label: 'Non-existent',
          );
          final updatedExisting = existingMuscleGroup.copyWith(
            description: 'Should not persist',
          );

          expect(
            () async => await muscleGroupDao.batchUpdate([
              updatedExisting,
              nonExistentMuscleGroup,
            ]),
            throwsA(isA<Exception>()),
          );

          // Verify rollback - original data unchanged
          final retrieved = await muscleGroupDao.getById(
            existingMuscleGroup.id,
          );
          expect(retrieved!.description, equals('Original'));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should delete existing muscle group successfully', () async {
        await muscleGroupDao.delete(testMuscleGroup.id);
        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expect(retrieved, isNull);
      });

      test(
        'should throw an exception when trying to delete non-existent muscle group',
        () async {
          expect(
            () async => await muscleGroupDao.delete('99999'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
