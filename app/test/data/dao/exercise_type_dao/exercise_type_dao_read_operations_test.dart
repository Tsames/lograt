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

  group('ExerciseTypeDao Read Operations Tests', () {
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

      await exerciseTypeDao.insert(testExerciseType);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should retrieve exercise type by ID correctly', () async {
      final retrieved = await exerciseTypeDao.getById(testExerciseType.id);

      expect(retrieved, isNotNull);
      expect(retrieved, isA<ExerciseTypeModel>());
      expect(retrieved!.id, equals(testExerciseType.id));
      expect(retrieved.name, equals('Bench Press'));
      expect(
        retrieved.description,
        equals('Standard flat bench barbell press'),
      );
    });

    test('should retrieve exercise type by name correctly', () async {
      final retrieved = await exerciseTypeDao.getByName('Bench Press');

      expect(retrieved, isNotNull);
      expect(retrieved, isA<ExerciseTypeModel>());
      expect(retrieved!.id, equals(testExerciseType.id));
      expect(retrieved.name, equals('Bench Press'));
    });

    test('should return null when exercise type does not exist', () async {
      final nonExistentById = await exerciseTypeDao.getById('99999');
      final nonExistentByName = await exerciseTypeDao.getByName(
        'Non-existent Exercise',
      );

      // Both methods should handle missing data
      expect(nonExistentById, isNull);
      expect(nonExistentByName, isNull);
    });

    test('should retrieve all exercise types ordered by name', () async {
      final squatType = ExerciseTypeModel.forTest(
        name: 'Squat',
        description: 'Leg exercise',
      );
      final deadliftType = ExerciseTypeModel.forTest(
        name: 'Deadlift',
        description: 'Full body exercise',
      );

      await exerciseTypeDao.insert(squatType);
      await exerciseTypeDao.insert(deadliftType);

      final allTypes = await exerciseTypeDao.getAll();

      expect(allTypes.length, equals(3));
      expect(allTypes, everyElement(isA<ExerciseTypeModel>()));

      expect(allTypes[0].name, equals('Bench Press'));
      expect(allTypes[1].name, equals('Deadlift'));
      expect(allTypes[2].name, equals('Squat'));
    });

    test('should return empty list when no exercise types exist', () async {
      await exerciseTypeDao.deleteById(testExerciseType.id);
      final allTypes = await exerciseTypeDao.getAll();

      expect(allTypes, isEmpty);
      expect(allTypes, isA<List<ExerciseTypeModel>>());
    });
  });
}
