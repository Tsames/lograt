import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('ExerciseTypeDao Update Operations Tests', () {
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

    test('should update existing exercise type successfully', () async {
      final updatedExerciseType = testExerciseType.copyWith(
        name: 'Incline Bench Press',
        description: 'Bench press performed on an inclined bench',
      );

      final correctlyUpdated = await exerciseTypeDao.updateById(
        updatedExerciseType,
      );

      expect(correctlyUpdated, equals(true));

      final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
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
          id: '99999',
          name: 'Ghost Exercise',
          description: 'This exercise type does not exist in the database',
        );

        final correctlyUpdated = await exerciseTypeDao.updateById(
          nonExistentExerciseType,
        );

        expect(correctlyUpdated, equals(false));
      },
    );
  });
}
