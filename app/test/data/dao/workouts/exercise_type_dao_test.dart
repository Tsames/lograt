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

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.name,
      equals(expected.name),
      reason: 'Field "name" does not match',
    );
    expect(
      actual.description,
      equals(expected.description),
      reason: 'Field "description" does not match',
    );
  }

  group('ExerciseTypeDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTypeDao exerciseTypeDao;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTypeDao = ExerciseTypeDao(testDatabase);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllExerciseTypesPaginatedSorted', () {
      test(
        'should retrieve all exercise types ordered by name ascending',
        () async {
          final exerciseTypes = [
            ExerciseTypeModel.forTest(name: 'Squat', description: 'Legs'),
            ExerciseTypeModel.forTest(
              name: 'Bench Press',
              description: 'Chest',
            ),
            ExerciseTypeModel.forTest(name: 'Deadlift', description: 'Back'),
          ];

          await exerciseTypeDao.batchInsert(exerciseTypes);

          final retrieved = await exerciseTypeDao
              .getAllExerciseTypesPaginatedSorted();

          expect(retrieved.length, equals(3));

          // Verify alphabetical ordering
          expectExerciseTypesEqual(retrieved[0], exerciseTypes[1]);
          expectExerciseTypesEqual(retrieved[1], exerciseTypes[2]);
          expectExerciseTypesEqual(retrieved[2], exerciseTypes[0]);
        },
      );

      test('should return empty list when no exercise types exist', () async {
        final exerciseTypes = await exerciseTypeDao
            .getAllExerciseTypesPaginatedSorted();

        expect(exerciseTypes, isEmpty);
        expect(exerciseTypes, isA<List<ExerciseTypeModel>>());
      });

      test('should respect pagination limit', () async {
        final exerciseTypes = [
          ExerciseTypeModel.forTest(name: 'A Exercise'),
          ExerciseTypeModel.forTest(name: 'B Exercise'),
          ExerciseTypeModel.forTest(name: 'C Exercise'),
          ExerciseTypeModel.forTest(name: 'D Exercise'),
        ];

        await exerciseTypeDao.batchInsert(exerciseTypes);

        final limited = await exerciseTypeDao
            .getAllExerciseTypesPaginatedSorted(limit: 2);

        expect(limited.length, equals(2));
        expectExerciseTypesEqual(limited[0], exerciseTypes[0]);
        expectExerciseTypesEqual(limited[1], exerciseTypes[1]);
      });

      test('should respect pagination offset', () async {
        final exerciseTypes = [
          ExerciseTypeModel.forTest(name: 'A Exercise'),
          ExerciseTypeModel.forTest(name: 'B Exercise'),
          ExerciseTypeModel.forTest(name: 'C Exercise'),
          ExerciseTypeModel.forTest(name: 'D Exercise'),
        ];

        await exerciseTypeDao.batchInsert(exerciseTypes);

        final page2 = await exerciseTypeDao.getAllExerciseTypesPaginatedSorted(
          limit: 2,
          offset: 2,
        );

        expect(page2.length, equals(2));
        expectExerciseTypesEqual(page2[0], exerciseTypes[2]);
        expectExerciseTypesEqual(page2[1], exerciseTypes[3]);
      });
    });

    group('getByName', () {
      test('should retrieve exercise type by name correctly', () async {
        final exerciseType = ExerciseTypeModel.forTest(
          name: 'Bench Press',
          description: 'Chest exercise',
        );
        await exerciseTypeDao.insert(exerciseType);

        final retrieved = await exerciseTypeDao.getByName('Bench Press');

        expectExerciseTypesEqual(retrieved, exerciseType);
      });

      test(
        'should return null when exercise type with name does not exist',
        () async {
          final retrieved = await exerciseTypeDao.getByName(
            'Non-existent Exercise',
          );

          expect(retrieved, isNull);
        },
      );
    });

    group('Table Constraints', () {
      test(
        'should throw exception when inserting exercise type with duplicate name',
        () async {
          final exerciseType1 = ExerciseTypeModel.forTest(
            name: 'Bench Press',
            description: 'Chest',
          );
          final exerciseType2 = ExerciseTypeModel.forTest(
            name: 'Bench Press',
            description: 'Different description',
          );

          await exerciseTypeDao.insert(exerciseType1);

          expect(
            () async => await exerciseTypeDao.insert(exerciseType2),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
