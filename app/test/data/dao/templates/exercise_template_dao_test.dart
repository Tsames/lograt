import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectExerciseTemplatesEqual(
    ExerciseTemplateModel? actual,
    ExerciseTemplateModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected exercise template to exist but got null',
    );

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.order,
      equals(expected.order),
      reason: 'Field "order" does not match',
    );
    expect(
      actual.workoutTemplateId,
      equals(expected.workoutTemplateId),
      reason: 'Field "workoutTemplateId" does not match',
    );
    expect(
      actual.exerciseTypeId,
      equals(expected.exerciseTypeId),
      reason: 'Field "exerciseTypeId" does not match',
    );
  }

  group('ExerciseTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTemplateDao exerciseTemplateDao;
    late WorkoutTemplateDao workoutTemplateDao;
    late ExerciseTypeDao exerciseTypeDao;

    late WorkoutTemplateModel testWorkoutTemplate;
    late ExerciseTypeModel testExerciseType;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testWorkoutTemplate = WorkoutTemplateModel.forTest(
        title: 'Test Workout Template',
      );
      await workoutTemplateDao.insert(testWorkoutTemplate);

      testExerciseType = ExerciseTypeModel.forTest(name: 'Bench Press');
      await exerciseTypeDao.insert(testExerciseType);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllExerciseTemplatesWithWorkoutTemplateId', () {
      test(
        'should retrieve all exercise templates for a workout template',
        () async {
          final exerciseTemplates = [
            ExerciseTemplateModel.forTest(
              workoutTemplateId: testWorkoutTemplate.id,
              order: 1,
            ),
            ExerciseTemplateModel.forTest(
              workoutTemplateId: testWorkoutTemplate.id,
              order: 2,
            ),
            ExerciseTemplateModel.forTest(
              workoutTemplateId: testWorkoutTemplate.id,
              order: 3,
            ),
          ];

          await exerciseTemplateDao.batchInsert(exerciseTemplates);

          final retrieved = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );

          expect(retrieved.length, equals(3));
        },
      );

      test(
        'should return empty list when workout template has no exercise templates',
        () async {
          final exerciseTemplates = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );

          expect(exerciseTemplates, isEmpty);
          expect(exerciseTemplates, isA<List<ExerciseTemplateModel>>());
        },
      );

      test(
        'should only return exercise templates for specified workout template',
        () async {
          final workoutTemplate2 = WorkoutTemplateModel.forTest(
            title: 'Other Template',
          );
          await workoutTemplateDao.insert(workoutTemplate2);

          final exercise1 = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 1,
          );
          final exercise2 = ExerciseTemplateModel.forTest(
            workoutTemplateId: workoutTemplate2.id,
            order: 1,
          );

          await exerciseTemplateDao.insert(exercise1);
          await exerciseTemplateDao.insert(exercise2);

          final template1Exercises = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );
          final template2Exercises = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                workoutTemplate2.id,
              );

          expect(template1Exercises.length, equals(1));
          expect(template2Exercises.length, equals(1));
          expectExerciseTemplatesEqual(template1Exercises[0], exercise1);
          expectExerciseTemplatesEqual(template2Exercises[0], exercise2);
        },
      );
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete exercise templates when workout template is deleted',
        () async {
          final exerciseTemplate = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 1,
          );
          await exerciseTemplateDao.insert(exerciseTemplate);

          // Verify exercise template exists
          expect(
            await exerciseTemplateDao.getById(exerciseTemplate.id),
            isNotNull,
          );

          // Delete the workout template
          await workoutTemplateDao.delete(testWorkoutTemplate.id);

          // Exercise template should be deleted due to CASCADE
          expect(
            await exerciseTemplateDao.getById(exerciseTemplate.id),
            isNull,
          );
        },
      );

      test(
        'should CASCADE delete exercise templates when exercise type is deleted',
        () async {
          final exerciseTemplate = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            exerciseTypeId: testExerciseType.id,
            order: 1,
          );
          await exerciseTemplateDao.insert(exerciseTemplate);

          // Verify exercise template exists
          expect(
            await exerciseTemplateDao.getById(exerciseTemplate.id),
            isNotNull,
          );

          // Delete the exercise type
          await exerciseTypeDao.delete(testExerciseType.id);

          // Exercise template should be deleted due to CASCADE
          expect(
            await exerciseTemplateDao.getById(exerciseTemplate.id),
            isNull,
          );
        },
      );

      test(
        'should throw exception when inserting with non-existent workout template',
        () async {
          final exerciseTemplate = ExerciseTemplateModel(
            id: 'test',
            workoutTemplateId: 'non-existent',
            order: 1,
          );

          expect(
            () async => await exerciseTemplateDao.insert(exerciseTemplate),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
