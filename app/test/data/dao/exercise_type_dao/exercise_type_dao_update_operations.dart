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

  group('ExerciseTypeDao Update Operations Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTypeDao exerciseTypeDao;
    late ExerciseTypeModel sampleExerciseType;

    late int existingExerciseTypeId;
    late ExerciseTypeModel existingExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      sampleExerciseType = ExerciseTypeModel(
        name: 'Bench Press',
        description: 'Standard flat bench barbell press',
      );
      existingExerciseTypeId = await exerciseTypeDao.insert(sampleExerciseType);

      existingExerciseType = (await exerciseTypeDao.getById(
        existingExerciseTypeId,
      ))!;
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should update existing exercise type successfully', () async {
      final updatedExerciseType = existingExerciseType.copyWith(
        name: 'Incline Bench Press',
        description: 'Bench press performed on an inclined bench',
      );

      final correctlyUpdated = await exerciseTypeDao.updateById(
        updatedExerciseType,
      );

      expect(correctlyUpdated, equals(true));

      final retrieved = await exerciseTypeDao.getById(existingExerciseTypeId);
      expect(retrieved!.name, equals('Incline Bench Press'));
      expect(
        retrieved.description,
        equals('Bench press performed on an inclined bench'),
      );
    });

    test(
      'should return false when trying to update non-existent exercise type',
      () async {
        final nonExistentExerciseType = ExerciseTypeModel(
          id: 99999,
          name: 'Ghost Exercise',
          description: 'This exercise type does not exist in the database',
        );

        final correctlyUpdated = await exerciseTypeDao.updateById(
          nonExistentExerciseType,
        );

        expect(correctlyUpdated, equals(false));
      },
    );

    test(
      'should throw ArgumentError when trying to update exercise type without ID',
      () async {
        final exerciseTypeWithoutId = ExerciseTypeModel(
          name: 'Test Exercise',
          description: 'Exercise without ID',
        );

        expect(
          () async => await exerciseTypeDao.updateById(exerciseTypeWithoutId),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
