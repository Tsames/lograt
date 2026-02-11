import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
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

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.label,
      equals(expected.label),
      reason: 'Field "label" does not match',
    );
    expect(
      actual.description,
      equals(expected.description),
      reason: 'Field "description" does not match',
    );
  }

  group('MuscleGroupDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupDao muscleGroupDao;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupDao = MuscleGroupDao(testDatabase);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getByName', () {
      test('should retrieve muscle group by label correctly', () async {
        final muscleGroup = MuscleGroupModel.forTest(
          label: 'Chest',
          description: 'Pectoral muscles',
        );
        await muscleGroupDao.insert(muscleGroup);

        final retrieved = await muscleGroupDao.getByLabel('Chest');

        expectMuscleGroupsEqual(retrieved, muscleGroup);
      });

      test(
        'should return null when muscle group with label does not exist',
        () async {
          final retrieved = await muscleGroupDao.getByLabel(
            'Non-existent Muscle Group',
          );

          expect(retrieved, isNull);
        },
      );
    });

    group('getMuscleGroupsByIds', () {
      test('should retrieve multiple muscle groups by ids', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Chest'),
          MuscleGroupModel.forTest(label: 'Back'),
          MuscleGroupModel.forTest(label: 'Legs'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        final retrieved = await muscleGroupDao.getMuscleGroupsByIds([
          muscleGroups[0].id,
          muscleGroups[2].id,
        ]);

        expect(retrieved.length, equals(2));
      });

      test('should return empty list when no ids match', () async {
        final muscleGroup = MuscleGroupModel.forTest(label: 'Chest');
        await muscleGroupDao.insert(muscleGroup);

        final retrieved = await muscleGroupDao.getMuscleGroupsByIds([
          'non-existent-id',
        ]);

        expect(retrieved, isEmpty);
      });

      test('should throw exception when given empty list', () async {
        expect(
          () async => await muscleGroupDao.getMuscleGroupsByIds([]),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getAllMuscleGroupsPaginatedSorted', () {
      test(
        'should retrieve all muscle groups ordered by label ascending',
        () async {
          final muscleGroups = [
            MuscleGroupModel.forTest(label: 'Legs', description: 'Quadriceps'),
            MuscleGroupModel.forTest(label: 'Back', description: 'Latissimus'),
            MuscleGroupModel.forTest(label: 'Chest', description: 'Pectorals'),
          ];

          await muscleGroupDao.batchInsert(muscleGroups);

          final retrieved = await muscleGroupDao
              .getAllMuscleGroupsPaginatedSorted();

          expect(retrieved.length, equals(3));

          // Verify alphabetical ordering
          expectMuscleGroupsEqual(retrieved[0], muscleGroups[1]);
          expectMuscleGroupsEqual(retrieved[1], muscleGroups[2]);
          expectMuscleGroupsEqual(retrieved[2], muscleGroups[0]);
        },
      );

      test('should return empty list when no muscle groups exist', () async {
        final muscleGroups = await muscleGroupDao
            .getAllMuscleGroupsPaginatedSorted();

        expect(muscleGroups, isEmpty);
        expect(muscleGroups, isA<List<MuscleGroupModel>>());
      });

      test('should respect pagination limit', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Abdominals'),
          MuscleGroupModel.forTest(label: 'Biceps'),
          MuscleGroupModel.forTest(label: 'Chest'),
          MuscleGroupModel.forTest(label: 'Deltoids'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        final limited = await muscleGroupDao.getAllMuscleGroupsPaginatedSorted(
          limit: 2,
        );

        expect(limited.length, equals(2));
        expectMuscleGroupsEqual(limited[0], muscleGroups[0]);
        expectMuscleGroupsEqual(limited[1], muscleGroups[1]);
      });

      test('should respect pagination offset', () async {
        final muscleGroups = [
          MuscleGroupModel.forTest(label: 'Abdominals'),
          MuscleGroupModel.forTest(label: 'Biceps'),
          MuscleGroupModel.forTest(label: 'Chest'),
          MuscleGroupModel.forTest(label: 'Deltoids'),
        ];

        await muscleGroupDao.batchInsert(muscleGroups);

        final page2 = await muscleGroupDao.getAllMuscleGroupsPaginatedSorted(
          limit: 2,
          offset: 2,
        );

        expect(page2.length, equals(2));
        expectMuscleGroupsEqual(page2[0], muscleGroups[2]);
        expectMuscleGroupsEqual(page2[1], muscleGroups[3]);
      });
    });

    group('Table Constraints', () {
      test(
        'should throw exception when inserting muscle group with duplicate label',
        () async {
          final muscleGroup1 = MuscleGroupModel.forTest(
            label: 'Chest',
            description: 'Pectorals',
          );
          final muscleGroup2 = MuscleGroupModel.forTest(
            label: 'Chest',
            description: 'Different description',
          );

          await muscleGroupDao.insert(muscleGroup1);

          expect(
            () async => await muscleGroupDao.insert(muscleGroup2),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
