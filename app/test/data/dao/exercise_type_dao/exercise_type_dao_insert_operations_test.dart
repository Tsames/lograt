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

  group('ExerciseTypeDao Insert Operations Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTypeDao exerciseTypeDao;

    late ExerciseTypeModel testExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testExerciseType = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Standard flat bench barbell press',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should insert a new exercise type correctly', () async {
      await exerciseTypeDao.insert(testExerciseType);

      final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals(testExerciseType.name));
      expect(retrieved.description, equals(testExerciseType.description));
    });

    test('should handle inserting exercise type with minimal data', () async {
      final minimalExerciseType = ExerciseTypeModel.forTest(
        name: 'Push-ups',
        description: null,
      );

      await exerciseTypeDao.insert(minimalExerciseType);

      final retrieved = await exerciseTypeDao.getById(minimalExerciseType.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Push-ups'));
      expect(retrieved.description, isNull);
    });

    test('should handle transaction-based insert correctly', () async {
      final database = await testDatabase.database;

      await database.transaction((txn) async {
        await exerciseTypeDao.insert(testExerciseType, txn);
      });

      final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals(testExerciseType.name));
      expect(retrieved.description, equals(testExerciseType.description));
    });

    test(
      'should throw exception when trying to insert duplicate name',
      () async {
        await exerciseTypeDao.insert(testExerciseType);

        final duplicateExerciseType = ExerciseTypeModel.forTest(
          name: 'Bench Press', // Same name
          description: 'Different description',
        );

        expect(
          () async => await exerciseTypeDao.insert(duplicateExerciseType),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
