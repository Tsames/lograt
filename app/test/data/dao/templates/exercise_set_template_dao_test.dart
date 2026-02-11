import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/templates/exercise_set_template_dao.dart';
import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectExerciseSetTemplatesEqual(
    ExerciseSetTemplateModel? actual,
    ExerciseSetTemplateModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected exercise set template to exist but got null',
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
      actual.exerciseTemplateId,
      equals(expected.exerciseTemplateId),
      reason: 'Field "exerciseTemplateId" does not match',
    );
    expect(
      actual.setType,
      equals(expected.setType),
      reason: 'Field "setType" does not match',
    );
    expect(
      actual.units,
      equals(expected.units),
      reason: 'Field "units" does not match',
    );
  }

  group('ExerciseSetTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseSetTemplateDao exerciseSetTemplateDao;
    late ExerciseTemplateDao exerciseTemplateDao;
    late WorkoutTemplateDao workoutTemplateDao;

    late WorkoutTemplateModel testWorkoutTemplate;
    late ExerciseTemplateModel testExerciseTemplate;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseSetTemplateDao = ExerciseSetTemplateDao(testDatabase);
      exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      testWorkoutTemplate = WorkoutTemplateModel.forTest(
        title: 'Test Workout Template',
      );
      await workoutTemplateDao.insert(testWorkoutTemplate);

      testExerciseTemplate = ExerciseTemplateModel.forTest(
        workoutTemplateId: testWorkoutTemplate.id,
        order: 1,
      );
      await exerciseTemplateDao.insert(testExerciseTemplate);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllExerciseSetTemplatesWithExerciseTemplateId', () {
      test(
        'should retrieve all exercise set templates for an exercise template',
        () async {
          final setTemplates = [
            ExerciseSetTemplateModel.forTest(
              exerciseTemplateId: testExerciseTemplate.id,
              order: 1,
            ),
            ExerciseSetTemplateModel.forTest(
              exerciseTemplateId: testExerciseTemplate.id,
              order: 2,
            ),
            ExerciseSetTemplateModel.forTest(
              exerciseTemplateId: testExerciseTemplate.id,
              order: 3,
            ),
          ];

          await exerciseSetTemplateDao.batchInsert(setTemplates);

          final retrieved = await exerciseSetTemplateDao
              .getAllExerciseSetTemplatesWithExerciseTemplateId(
                testExerciseTemplate.id,
              );

          expect(retrieved.length, equals(3));
        },
      );

      test(
        'should return empty list when exercise template has no set templates',
        () async {
          final setTemplates = await exerciseSetTemplateDao
              .getAllExerciseSetTemplatesWithExerciseTemplateId(
                testExerciseTemplate.id,
              );

          expect(setTemplates, isEmpty);
          expect(setTemplates, isA<List<ExerciseSetTemplateModel>>());
        },
      );

      test(
        'should only return set templates for specified exercise template',
        () async {
          final exerciseTemplate2 = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 2,
          );
          await exerciseTemplateDao.insert(exerciseTemplate2);

          final set1 = ExerciseSetTemplateModel.forTest(
            exerciseTemplateId: testExerciseTemplate.id,
            order: 1,
          );
          final set2 = ExerciseSetTemplateModel.forTest(
            exerciseTemplateId: exerciseTemplate2.id,
            order: 1,
          );

          await exerciseSetTemplateDao.insert(set1);
          await exerciseSetTemplateDao.insert(set2);

          final template1Sets = await exerciseSetTemplateDao
              .getAllExerciseSetTemplatesWithExerciseTemplateId(
                testExerciseTemplate.id,
              );
          final template2Sets = await exerciseSetTemplateDao
              .getAllExerciseSetTemplatesWithExerciseTemplateId(
                exerciseTemplate2.id,
              );

          expect(template1Sets.length, equals(1));
          expect(template2Sets.length, equals(1));
          expectExerciseSetTemplatesEqual(template1Sets[0], set1);
          expectExerciseSetTemplatesEqual(template2Sets[0], set2);
        },
      );
    });

    group('Foreign Key Constraints', () {
      test(
        'should CASCADE delete exercise set templates when exercise template is deleted',
        () async {
          final setTemplate = ExerciseSetTemplateModel.forTest(
            exerciseTemplateId: testExerciseTemplate.id,
            order: 1,
          );
          await exerciseSetTemplateDao.insert(setTemplate);

          // Verify exercise set template exists
          expect(
            await exerciseSetTemplateDao.getById(setTemplate.id),
            isNotNull,
          );

          // Delete the exercise template
          await exerciseTemplateDao.delete(testExerciseTemplate.id);

          // Exercise set template should be deleted due to CASCADE
          expect(await exerciseSetTemplateDao.getById(setTemplate.id), isNull);
        },
      );

      test(
        'should throw exception when inserting with non-existent exercise template',
        () async {
          final setTemplate = ExerciseSetTemplateModel(
            id: 'test',
            exerciseTemplateId: 'non-existent',
            order: 1,
          );

          expect(
            () async => await exerciseSetTemplateDao.insert(setTemplate),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
