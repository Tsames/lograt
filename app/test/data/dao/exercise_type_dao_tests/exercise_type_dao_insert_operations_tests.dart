import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('ExerciseTypeDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTypeDao exerciseTypeDao;
    late ExerciseTypeModel sampleExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      sampleExerciseType = ExerciseTypeModel(
        name: 'Bench Press',
        description: 'Standard flat bench barbell press',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should insert a new exercise type and return a valid ID', () async {
      final insertedId = await exerciseTypeDao.insert(sampleExerciseType);

      expect(insertedId, isA<int>());
      expect(insertedId, greaterThan(0));

      final retrieved = await exerciseTypeDao.getById(insertedId);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Bench Press'));
      expect(
        retrieved.description,
        equals('Standard flat bench barbell press'),
      );
    });

    test('should handle inserting exercise type with minimal data', () async {
      final minimalExerciseType = ExerciseTypeModel(
        name: 'Push-ups',
        description: null, // Testing null description
      );

      final insertedId = await exerciseTypeDao.insert(minimalExerciseType);

      expect(insertedId, greaterThan(0));

      final retrieved = await exerciseTypeDao.getById(insertedId);
      expect(retrieved!.name, equals('Push-ups'));
      expect(retrieved.description, isNull);
    });

    test('should handle transaction-based insert correctly', () async {
      final database = await testDatabase.database;
      late int insertedId;

      await database.transaction((txn) async {
        insertedId = await exerciseTypeDao.insert(sampleExerciseType, txn);
      });

      expect(insertedId, greaterThan(0));

      final retrieved = await exerciseTypeDao.getById(insertedId);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals(sampleExerciseType.name));
    });

    test(
      'should throw exception when trying to insert duplicate name',
      () async {
        await exerciseTypeDao.insert(sampleExerciseType);

        final duplicateExerciseType = ExerciseTypeModel(
          name: 'Bench Press', // Same name as sampleExerciseType
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
