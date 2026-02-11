import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_template_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('MuscleGroupToWorkoutTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late MuscleGroupToWorkoutTemplateDao muscleGroupToWorkoutTemplateDao;
    late MuscleGroupDao muscleGroupDao;
    late WorkoutTemplateDao workoutTemplateDao;

    late MuscleGroupModel testMuscleGroup1;
    late MuscleGroupModel testMuscleGroup2;
    late WorkoutTemplateModel testWorkoutTemplate1;
    late WorkoutTemplateModel testWorkoutTemplate2;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      muscleGroupToWorkoutTemplateDao = MuscleGroupToWorkoutTemplateDao(
        testDatabase,
      );
      muscleGroupDao = MuscleGroupDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      testMuscleGroup1 = MuscleGroupModel.forTest(label: 'Chest');
      testMuscleGroup2 = MuscleGroupModel.forTest(label: 'Shoulders');

      await muscleGroupDao.insert(testMuscleGroup1);
      await muscleGroupDao.insert(testMuscleGroup2);

      testWorkoutTemplate1 = WorkoutTemplateModel.forTest(
        title: 'Push Day Template',
      );
      testWorkoutTemplate2 = WorkoutTemplateModel.forTest(
        title: 'Upper Body Template',
      );

      await workoutTemplateDao.insert(testWorkoutTemplate1);
      await workoutTemplateDao.insert(testWorkoutTemplate2);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete relationships when workout template is deleted',
        () async {
          final relationship = MuscleGroupToWorkoutTemplateModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );
          await muscleGroupToWorkoutTemplateDao.insertRelationship(
            relationship,
          );

          // Verify relationship exists
          final beforeDelete = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(relationship);
          expect(beforeDelete, isTrue);

          // Delete the workout template
          await workoutTemplateDao.delete(testWorkoutTemplate1.id);

          // Relationship should be automatically deleted due to CASCADE
          final afterDelete = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(relationship);
          expect(afterDelete, isFalse);
        },
      );

      test(
        'should CASCADE delete relationships when muscle group is deleted',
        () async {
          final relationship1 = MuscleGroupToWorkoutTemplateModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate1.id,
          );
          final relationship2 = MuscleGroupToWorkoutTemplateModel.createWithId(
            muscleGroupId: testMuscleGroup1.id,
            workoutTemplateId: testWorkoutTemplate2.id,
          );

          await muscleGroupToWorkoutTemplateDao.batchInsertRelationships([
            relationship1,
            relationship2,
          ]);

          // Delete the muscle group
          await muscleGroupDao.delete(testMuscleGroup1.id);

          // Both relationships should be deleted due to CASCADE
          final afterDelete1 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(relationship1);
          final afterDelete2 = await muscleGroupToWorkoutTemplateDao
              .relationshipExists(relationship2);
          expect(afterDelete1, isFalse);
          expect(afterDelete2, isFalse);
        },
      );
    });
  });
}
