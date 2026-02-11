import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_exercise_type_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_exercise_type_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('MuscleGroupToExerciseTypeDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupToExerciseTypeDao muscleGroupToExerciseTypeDao;
    late MuscleGroupDao muscleGroupDao;
    late ExerciseTypeDao exerciseTypeDao;

    late MuscleGroupModel testMuscleGroup1;
    late MuscleGroupModel testMuscleGroup2;
    late ExerciseTypeModel testExerciseType1;
    late ExerciseTypeModel testExerciseType2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToExerciseTypeDao = MuscleGroupToExerciseTypeDao(testDatabase);
      muscleGroupDao = MuscleGroupDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);

      testExerciseType1 = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      testExerciseType2 = ExerciseTypeModel.forTest(
        name: 'Overhead Press',
        description: 'Shoulder exercise',
      );

      await exerciseTypeDao.insert(testExerciseType1);
      await exerciseTypeDao.insert(testExerciseType2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when exercise type is deleted',
        () async {
          final relationship = MuscleGroupToExerciseTypeModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );
          await muscleGroupToExerciseTypeDao.insertRelationship(relationship);

          // Verify relationship exists
          final beforeDelete = await muscleGroupToExerciseTypeDao
              .relationshipExists(relationship);
          expect(beforeDelete, isTrue);

          // Delete the exercise type
          await exerciseTypeDao.delete(testExerciseType1.id);

          // Relationship should be automatically deleted due to CASCADE
          final afterDelete = await muscleGroupToExerciseTypeDao
              .relationshipExists(relationship);
          expect(afterDelete, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          final relationship1 = MuscleGroupToExerciseTypeModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType1.id,
          );
          final relationship2 = MuscleGroupToExerciseTypeModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            exerciseTypeId: testExerciseType2.id,
          );

          await muscleGroupToExerciseTypeDao.batchInsertRelationships([
            relationship1,
            relationship2,
          ]);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Both relationships should be deleted due to CASCADE
          final afterDelete1 = await muscleGroupToExerciseTypeDao
              .relationshipExists(relationship1);
          final afterDelete2 = await muscleGroupToExerciseTypeDao
              .relationshipExists(relationship2);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
