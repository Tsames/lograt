import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_groups_dao.dart';
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
    expect(actual, isNotNull);
    expect(actual!.id, equals(expected.id));
    expect(actual.label, equals(expected.label));
    expect(actual.description, equals(expected.description));
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
        'should throw exception when trying to insert duplicate label',
        () async {
          await muscleGroupDao.insert(testMuscleGroup);

          final duplicateMuscleGroup = MuscleGroupModel.forTest(
            label: 'Chest',
            description: 'Different description',
          );

          expect(
            () async => await muscleGroupDao.insert(duplicateMuscleGroup),
            throwsA(isA<DatabaseException>()),
          );
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should retrieve muscle group by ID correctly', () async {
        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test(
        'should return null when muscle group does not exist by ID',
        () async {
          final nonExistent = await muscleGroupDao.getById('99999');

          expect(nonExistent, isNull);
        },
      );

      test('should retrieve muscle group by label correctly', () async {
        final retrieved = await muscleGroupDao.getByName('Chest');
        expectMuscleGroupsEqual(retrieved, testMuscleGroup);
      });

      test(
        'should return null when muscle group does not exist by label',
        () async {
          final nonExistent = await muscleGroupDao.getByName('NonExistent');

          expect(nonExistent, isNull);
        },
      );

      test(
        'should retrieve all muscle groups ordered alphabetically',
        () async {
          final back = MuscleGroupModel.forTest(label: 'Back');
          final legs = MuscleGroupModel.forTest(label: 'Legs');
          final arms = MuscleGroupModel.forTest(label: 'Arms');

          await muscleGroupDao.insert(back);
          await muscleGroupDao.insert(legs);
          await muscleGroupDao.insert(arms);

          final allMuscleGroups = await muscleGroupDao.getAllMuscleGroups();

          expect(allMuscleGroups.length, equals(4));
          expect(allMuscleGroups, everyElement(isA<MuscleGroupModel>()));

          // Verify alphabetical order
          expect(allMuscleGroups[0].label, equals('Arms'));
          expect(allMuscleGroups[1].label, equals('Back'));
          expect(allMuscleGroups[2].label, equals('Chest'));
          expect(allMuscleGroups[3].label, equals('Legs'));
        },
      );

      test('should return empty list when no muscle groups exist', () async {
        await muscleGroupDao.clearTable();
        final allMuscleGroups = await muscleGroupDao.getAllMuscleGroups();

        expect(allMuscleGroups, isEmpty);
        expect(allMuscleGroups, isA<List<MuscleGroupModel>>());
      });

      test('should respect limit parameter in getAllMuscleGroups', () async {
        final back = MuscleGroupModel.forTest(label: 'Back');
        final legs = MuscleGroupModel.forTest(label: 'Legs');

        await muscleGroupDao.insert(back);
        await muscleGroupDao.insert(legs);

        final limitedResults = await muscleGroupDao.getAllMuscleGroups(
          limit: 2,
        );

        expect(limitedResults.length, equals(2));
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should update existing muscle group successfully', () async {
        final updatedMuscleGroup = testMuscleGroup.copyWith(
          label: 'Pectorals',
          description: 'Updated description',
        );

        final rowsAffected = await muscleGroupDao.update(updatedMuscleGroup);

        expect(rowsAffected, equals(1));

        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expectMuscleGroupsEqual(retrieved, updatedMuscleGroup);
      });

      test(
        'should return 0 when trying to update non-existent muscle group',
        () async {
          final nonExistentMuscleGroup = MuscleGroupModel(
            id: '99999',
            label: 'Ghost',
            description: 'Does not exist',
          );

          final rowsAffected = await muscleGroupDao.update(
            nonExistentMuscleGroup,
          );

          expect(rowsAffected, equals(0));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await muscleGroupDao.insert(testMuscleGroup);
      });

      test('should delete existing muscle group successfully', () async {
        final rowsDeleted = await muscleGroupDao.delete(testMuscleGroup.id);

        expect(rowsDeleted, equals(1));

        final retrieved = await muscleGroupDao.getById(testMuscleGroup.id);
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent muscle group',
        () async {
          final rowsDeleted = await muscleGroupDao.delete('99999');

          expect(rowsDeleted, equals(0));
        },
      );
    });
  });
}
