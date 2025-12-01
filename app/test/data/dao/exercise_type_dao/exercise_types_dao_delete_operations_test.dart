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

  group('ExerciseTypeDao Delete Operations Tests', () {
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

    test('should delete existing exercise type successfully', () async {
      final rowIsDeleted = await exerciseTypeDao.deleteById(
        testExerciseType.id,
      );

      expect(rowIsDeleted, equals(true));

      final retrieved = await exerciseTypeDao.getById(testExerciseType.id);
      expect(retrieved, isNull);
    });

    test(
      'should return false when trying to delete non-existent exercise type',
      () async {
        final correctlyDeletedRecord = await exerciseTypeDao.deleteById(
          '99999',
        );

        expect(correctlyDeletedRecord, equals(false));
      },
    );
  });
}
