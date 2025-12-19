import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectExerciseTypesEqual(
    ExerciseTypeModel? actual,
    ExerciseTypeModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected exercise type to exist but got null',
    );

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    for (final field in ExerciseTypeFields.values) {
      expect(
        actualMap[field],
        equals(expectedMap[field]),
        reason: 'Field "$field" does not match',
      );
    }
  }

  group('ExerciseTypeDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTypeDao exerciseTypeDao;
    late ExerciseTypeModel testExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testExerciseType = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new exercise type correctly', () async {
        await exerciseTypeDao.insert(testExerciseType);

        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
        expectExerciseTypesEqual(retrieved, testExerciseType);
      });

      test('should handle inserting exercise type with minimal data', () async {
        final minimalExerciseType = ExerciseTypeModel.forTest(name: 'Push-ups');

        await exerciseTypeDao.insert(minimalExerciseType);

        final retrieved = await exerciseTypeDao.getById(minimalExerciseType.id);
        expectExerciseTypesEqual(retrieved, minimalExerciseType);
      });

      test(
        'should throw exception when inserting exercise type with duplicate id',
        () async {
          final otherExerciseType = testExerciseType.copyWith(
            name: 'Different Name',
          );
          await exerciseTypeDao.insert(testExerciseType);
          expect(
            () async => await exerciseTypeDao.insert(otherExerciseType),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await exerciseTypeDao.insert(testExerciseType, txn);
          final retrieved = await exerciseTypeDao.getById(
            testExerciseType.id,
            txn,
          );
          expectExerciseTypesEqual(retrieved, testExerciseType);
        });

        // Verify it persisted after transaction
        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
        expectExerciseTypesEqual(retrieved, testExerciseType);
      });
    });

    group('Batch Insert Operations', () {
      test('should batch insert multiple exercise types correctly', () async {
        final exerciseTypes = [
          ExerciseTypeModel.forTest(name: 'Bench Press', description: 'Chest'),
          ExerciseTypeModel.forTest(name: 'Squat', description: 'Legs'),
          ExerciseTypeModel.forTest(name: 'Deadlift', description: 'Back'),
        ];

        await exerciseTypeDao.batchInsert(exerciseTypes);

        final allExerciseTypes = await exerciseTypeDao.getAllPaginated();
        expect(allExerciseTypes.length, equals(3));
        expect(allExerciseTypes, everyElement(isA<ExerciseTypeModel>()));

        // Verify they're sorted by name (ASC)
        expect(allExerciseTypes[0].name, equals('Bench Press'));
        expect(allExerciseTypes[1].name, equals('Deadlift'));
        expect(allExerciseTypes[2].name, equals('Squat'));
      });

      test('should handle empty list gracefully in batch insert', () async {
        await exerciseTypeDao.batchInsert([]);

        final allExerciseTypes = await exerciseTypeDao.getAllPaginated();
        expect(allExerciseTypes, isEmpty);
      });

      test(
        'should throw exception and rollback insertions when batch insert has duplicate id among valid exercise types',
        () async {
          await exerciseTypeDao.insert(testExerciseType);

          final exerciseTypes = [
            ExerciseTypeModel.forTest(name: 'Squat'),
            testExerciseType,
            ExerciseTypeModel.forTest(name: 'Deadlift'),
          ];

          expect(
            () async => await exerciseTypeDao.batchInsert(exerciseTypes),
            throwsA(isA<DatabaseException>()),
          );

          final allExerciseTypes = await exerciseTypeDao.getAllPaginated();
          expect(allExerciseTypes.length, equals(1));
          expectExerciseTypesEqual(allExerciseTypes.first, testExerciseType);
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await exerciseTypeDao.insert(testExerciseType);
      });

      test('should retrieve exercise type by id correctly', () async {
        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);

        expectExerciseTypesEqual(retrieved, testExerciseType);
      });

      test('should return null when exercise type does not exist', () async {
        final nonExistent = await exerciseTypeDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve exercise type by name correctly', () async {
        final retrieved = await exerciseTypeDao.getByName('Bench Press');

        expectExerciseTypesEqual(retrieved, testExerciseType);
      });

      test(
        'should return null when exercise type with name does not exist',
        () async {
          final nonExistent = await exerciseTypeDao.getByName(
            'Non-existent Exercise',
          );

          expect(nonExistent, isNull);
        },
      );

      test('should retrieve all exercise types ordered by name', () async {
        final squat = ExerciseTypeModel.forTest(
          name: 'Squat',
          description: 'Legs',
        );
        final deadlift = ExerciseTypeModel.forTest(
          name: 'Deadlift',
          description: 'Back',
        );

        await exerciseTypeDao.insert(squat);
        await exerciseTypeDao.insert(deadlift);

        final allExerciseTypes = await exerciseTypeDao.getAllPaginated();

        expect(allExerciseTypes.length, equals(3));
        expect(allExerciseTypes, everyElement(isA<ExerciseTypeModel>()));

        // Verify alphabetical ordering
        expect(allExerciseTypes[0].name, equals('Bench Press'));
        expect(allExerciseTypes[1].name, equals('Deadlift'));
        expect(allExerciseTypes[2].name, equals('Squat'));
      });

      test('should return empty list when no exercise types exist', () async {
        await exerciseTypeDao.delete(testExerciseType.id);

        final exerciseTypes = await exerciseTypeDao.getAllPaginated();

        expect(exerciseTypes, isEmpty);
        expect(exerciseTypes, isA<List<ExerciseTypeModel>>());
      });

      test('should respect pagination limit and offset', () async {
        final exerciseTypes = [
          ExerciseTypeModel.forTest(name: 'A Exercise'),
          ExerciseTypeModel.forTest(name: 'B Exercise'),
          ExerciseTypeModel.forTest(name: 'C Exercise'),
          ExerciseTypeModel.forTest(name: 'D Exercise'),
        ];

        await exerciseTypeDao.batchInsert(exerciseTypes);

        // Get first 2
        final page1 = await exerciseTypeDao.getAllPaginated(
          limit: 2,
          offset: 0,
        );
        expect(page1.length, equals(2));
        expect(page1[0].name, equals('A Exercise'));
        expect(page1[1].name, equals('B Exercise'));

        // Get next 2
        final page2 = await exerciseTypeDao.getAllPaginated(
          limit: 2,
          offset: 2,
        );
        expect(page2.length, equals(2));
        expect(page2[0].name, equals('Bench Press'));
        expect(page2[1].name, equals('C Exercise'));
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await exerciseTypeDao.insert(testExerciseType);
      });

      test('should update existing exercise type successfully', () async {
        final updatedExerciseType = testExerciseType.copyWith(
          name: 'Incline Bench Press',
          description: 'Upper chest',
        );

        await exerciseTypeDao.update(updatedExerciseType);

        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
        expectExerciseTypesEqual(retrieved, updatedExerciseType);
      });

      test(
        'should throw an exception when trying to update non-existent exercise type',
        () async {
          final nonExistentExerciseType = ExerciseTypeModel(
            id: '99999',
            name: 'Non-existent',
          );

          expect(
            () async => await exerciseTypeDao.update(nonExistentExerciseType),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Batch Update Operations', () {
      test('should batch update multiple exercise types correctly', () async {
        final exerciseTypes = [
          ExerciseTypeModel.forTest(
            name: 'Bench Press',
            description: 'Original 1',
          ),
          ExerciseTypeModel.forTest(name: 'Squat', description: 'Original 2'),
          ExerciseTypeModel.forTest(
            name: 'Deadlift',
            description: 'Original 3',
          ),
        ];

        await exerciseTypeDao.batchInsert(exerciseTypes);

        final updatedExerciseTypes = [
          exerciseTypes[0].copyWith(description: 'Updated 1'),
          exerciseTypes[1].copyWith(description: 'Updated 2'),
          exerciseTypes[2].copyWith(description: 'Updated 3'),
        ];

        await exerciseTypeDao.batchUpdate(updatedExerciseTypes);

        final retrieved1 = await exerciseTypeDao.getById(exerciseTypes[0].id);
        final retrieved2 = await exerciseTypeDao.getById(exerciseTypes[1].id);
        final retrieved3 = await exerciseTypeDao.getById(exerciseTypes[2].id);

        expectExerciseTypesEqual(retrieved1, updatedExerciseTypes[0]);
        expectExerciseTypesEqual(retrieved2, updatedExerciseTypes[1]);
        expectExerciseTypesEqual(retrieved3, updatedExerciseTypes[2]);
      });

      test('should handle empty list gracefully in batch update', () async {
        await exerciseTypeDao.insert(testExerciseType);

        await exerciseTypeDao.batchUpdate([]);

        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
        expectExerciseTypesEqual(retrieved, testExerciseType);
      });

      test(
        'should throw exception and rollback all updates when one exercise type does not exist',
        () async {
          final existingExerciseType = ExerciseTypeModel.forTest(
            name: 'Bench Press',
            description: 'Original',
          );
          await exerciseTypeDao.insert(existingExerciseType);

          final nonExistentExerciseType = ExerciseTypeModel(
            id: 'non-existent',
            name: 'Non-existent',
          );
          final updatedExisting = existingExerciseType.copyWith(
            description: 'Should not persist',
          );

          expect(
            () async => await exerciseTypeDao.batchUpdate([
              updatedExisting,
              nonExistentExerciseType,
            ]),
            throwsA(isA<Exception>()),
          );

          // Verify rollback - original data unchanged
          final retrieved = await exerciseTypeDao.getById(
            existingExerciseType.id,
          );
          expect(retrieved!.description, equals('Original'));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await exerciseTypeDao.insert(testExerciseType);
      });

      test('should delete existing exercise type successfully', () async {
        await exerciseTypeDao.delete(testExerciseType.id);
        final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
        expect(retrieved, isNull);
      });

      test(
        'should throw an exception when trying to delete non-existent exercise type',
        () async {
          expect(
            () async => await exerciseTypeDao.delete('99999'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
