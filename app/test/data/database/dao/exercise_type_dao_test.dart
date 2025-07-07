import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/database/dao/exercise_type_dao.dart';
import 'package:lograt/data/models/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lograt/data/database/app_database.dart';

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

      sampleExerciseType = ExerciseTypeModel(name: 'Bench Press', description: 'Standard flat bench barbell press');
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new exercise type and return a valid ID', () async {
        final insertedId = await exerciseTypeDao.insert(sampleExerciseType);

        expect(insertedId, isA<int>());
        expect(insertedId, greaterThan(0));

        final retrieved = await exerciseTypeDao.getById(insertedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals('Bench Press'));
        expect(retrieved.description, equals('Standard flat bench barbell press'));
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
          insertedId = await exerciseTypeDao.insertWithTransaction(exerciseType: sampleExerciseType, txn: txn);
        });

        expect(insertedId, greaterThan(0));

        final retrieved = await exerciseTypeDao.getById(insertedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals(sampleExerciseType.name));
      });

      test('should throw exception when trying to insert duplicate name', () async {
        await exerciseTypeDao.insert(sampleExerciseType);

        final duplicateExerciseType = ExerciseTypeModel(
          name: 'Bench Press', // Same name as sampleExerciseType
          description: 'Different description',
        );

        expect(() async => await exerciseTypeDao.insert(duplicateExerciseType), throwsA(isA<Exception>()));
      });
    });

    group('Read Operations', () {
      late int existingExerciseTypeId;

      setUp(() async {
        existingExerciseTypeId = await exerciseTypeDao.insert(sampleExerciseType);
      });

      test('should retrieve exercise type by ID as ExerciseTypeModel', () async {
        final retrieved = await exerciseTypeDao.getById(existingExerciseTypeId);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<ExerciseTypeModel>());
        expect(retrieved!.id, equals(existingExerciseTypeId));
        expect(retrieved.name, equals('Bench Press'));
        expect(retrieved.description, equals('Standard flat bench barbell press'));
      });

      test('should retrieve exercise type by name', () async {
        final retrieved = await exerciseTypeDao.getByName('Bench Press');

        expect(retrieved, isNotNull);
        expect(retrieved, isA<ExerciseTypeModel>());
        expect(retrieved!.id, equals(existingExerciseTypeId));
        expect(retrieved.name, equals('Bench Press'));
      });

      test('should return null when exercise type does not exist', () async {
        final nonExistentById = await exerciseTypeDao.getById(99999);
        final nonExistentByName = await exerciseTypeDao.getByName('Non-existent Exercise');

        // Both methods should handle missing data
        expect(nonExistentById, isNull);
        expect(nonExistentByName, isNull);
      });

      test('should retrieve all exercise types ordered by name', () async {
        final squatType = ExerciseTypeModel(name: 'Squat', description: 'Leg exercise');
        final deadliftType = ExerciseTypeModel(name: 'Deadlift', description: 'Full body exercise');

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
        await testDatabase.close();
        testDatabase = AppDatabase.inMemory();
        exerciseTypeDao = ExerciseTypeDao(testDatabase);

        final allTypes = await exerciseTypeDao.getAll();

        expect(allTypes, isEmpty);
        expect(allTypes, isA<List<ExerciseTypeModel>>());
      });

      test('should search exercise types by partial name match', () async {
        final pushUpType = ExerciseTypeModel(name: 'Push-ups', description: 'Bodyweight chest exercise');
        final pullUpType = ExerciseTypeModel(name: 'Pull-ups', description: 'Bodyweight back exercise');
        final benchPressType = ExerciseTypeModel(name: 'Incline Bench Press', description: 'Angled bench press');

        await exerciseTypeDao.insert(pushUpType);
        await exerciseTypeDao.insert(pullUpType);
        await exerciseTypeDao.insert(benchPressType);

        final pressExercises = await exerciseTypeDao.searchByName('press');

        final upExercises = await exerciseTypeDao.searchByName('up');

        expect(pressExercises.length, equals(2));
        expect(pressExercises.every((ex) => ex.name.toLowerCase().contains('press')), isTrue);

        expect(upExercises.length, equals(2));
        expect(upExercises.every((ex) => ex.name.toLowerCase().contains('up')), isTrue);
      });

      test('should return empty list when search finds no matches', () async {
        final noMatches = await exerciseTypeDao.searchByName('NonexistentExercise');

        expect(noMatches, isEmpty);
        expect(noMatches, isA<List<ExerciseTypeModel>>());
      });

      test('should return correct count of exercise types', () async {
        await exerciseTypeDao.insert(ExerciseTypeModel(name: 'Squat', description: 'Leg exercise'));
        await exerciseTypeDao.insert(ExerciseTypeModel(name: 'Deadlift', description: 'Full body exercise'));

        final count = await exerciseTypeDao.getCount();

        expect(count, equals(3));
        expect(count, isA<int>());
      });

      test('should correctly check if exercise type name exists', () async {
        final existsTrue = await exerciseTypeDao.nameExists('Bench Press');
        final existsFalse = await exerciseTypeDao.nameExists('Nonexistent Exercise');

        expect(existsTrue, isTrue);
        expect(existsFalse, isFalse);
      });
    });

    group('Update Operations', () {
      late int existingExerciseTypeId;
      late ExerciseTypeModel existingExerciseType;

      setUp(() async {
        existingExerciseTypeId = await exerciseTypeDao.insert(sampleExerciseType);
        existingExerciseType = (await exerciseTypeDao.getById(existingExerciseTypeId))!;
      });

      test('should update existing exercise type successfully', () async {
        final updatedExerciseType = existingExerciseType.copyWith(
          name: 'Incline Bench Press',
          description: 'Bench press performed on an inclined bench',
        );

        final rowsAffected = await exerciseTypeDao.update(updatedExerciseType);

        expect(rowsAffected, equals(1));

        final retrieved = await exerciseTypeDao.getById(existingExerciseTypeId);
        expect(retrieved!.name, equals('Incline Bench Press'));
        expect(retrieved.description, equals('Bench press performed on an inclined bench'));
      });

      test('should return 0 when trying to update non-existent exercise type', () async {
        final nonExistentExerciseType = ExerciseTypeModel(
          id: 99999,
          name: 'Ghost Exercise',
          description: 'This exercise type does not exist in the database',
        );

        final rowsAffected = await exerciseTypeDao.update(nonExistentExerciseType);

        expect(rowsAffected, equals(0));
      });

      test('should throw ArgumentError when trying to update exercise type without ID', () async {
        final exerciseTypeWithoutId = ExerciseTypeModel(name: 'Test Exercise', description: 'Exercise without ID');

        expect(() async => await exerciseTypeDao.update(exerciseTypeWithoutId), throwsA(isA<ArgumentError>()));
      });
    });

    group('Delete Operations', () {
      late int existingExerciseTypeId;

      setUp(() async {
        existingExerciseTypeId = await exerciseTypeDao.insert(sampleExerciseType);
      });

      test('should delete existing exercise type successfully', () async {
        final rowsDeleted = await exerciseTypeDao.delete(existingExerciseTypeId);

        expect(rowsDeleted, equals(1));

        final retrieved = await exerciseTypeDao.getById(existingExerciseTypeId);
        expect(retrieved, isNull);
      });

      test('should return 0 when trying to delete non-existent exercise type', () async {
        final rowsDeleted = await exerciseTypeDao.delete(99999);

        expect(rowsDeleted, equals(0));
      });
    });
  });
}
