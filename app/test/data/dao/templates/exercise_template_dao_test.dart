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
    expect(actual, isNotNull);
    expect(actual!.id, equals(expected.id));
    expect(actual.workoutTemplateId, equals(expected.workoutTemplateId));
    expect(actual.exerciseTypeId, equals(expected.exerciseTypeId));
    expect(actual.order, equals(expected.order));
  }

  group('ExerciseTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late ExerciseTemplateDao exerciseTemplateDao;
    late WorkoutTemplateDao workoutTemplateDao;
    late ExerciseTypeDao exerciseTypeDao;

    late WorkoutTemplateModel testWorkoutTemplate;
    late ExerciseTypeModel testExerciseType;
    late ExerciseTemplateModel testExerciseTemplate;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);
      exerciseTypeDao = ExerciseTypeDao(testDatabase);

      testWorkoutTemplate = WorkoutTemplateModel.forTest(
        description: 'Test Workout Template',
      );
      await workoutTemplateDao.insert(testWorkoutTemplate);

      testExerciseType = ExerciseTypeModel.forTest(
        name: 'Bench Press',
        description: 'Chest exercise',
      );
      await exerciseTypeDao.insert(testExerciseType);

      testExerciseTemplate = ExerciseTemplateModel.forTest(
        workoutTemplateId: testWorkoutTemplate.id,
        exerciseTypeId: testExerciseType.id,
        order: 1,
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new exercise template correctly', () async {
        await exerciseTemplateDao.insert(testExerciseTemplate);

        final retrieved = await exerciseTemplateDao.getById(
          testExerciseTemplate.id,
        );
        expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
      });

      test(
        'should handle inserting exercise template with minimal data',
        () async {
          final minimalTemplate = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
          );

          await exerciseTemplateDao.insert(minimalTemplate);

          final retrieved = await exerciseTemplateDao.getById(
            minimalTemplate.id,
          );
          expectExerciseTemplatesEqual(retrieved, minimalTemplate);
        },
      );
    });

    group('Batch Insert Operations', () {
      test(
        'should batch insert multiple exercise templates correctly',
        () async {
          final templates = [
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

          await exerciseTemplateDao.batchInsert(templates);

          final allTemplates = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );
          expect(allTemplates.length, equals(3));
          for (int i = 0; i < templates.length; i++) {
            final retrieved = await exerciseTemplateDao.getById(
              templates[i].id,
            );
            expectExerciseTemplatesEqual(retrieved, templates[i]);
          }
        },
      );

      test('should handle empty list gracefully in batch insert', () async {
        await exerciseTemplateDao.batchInsert([]);

        final allTemplates = await exerciseTemplateDao
            .getAllExerciseTemplatesWithWorkoutTemplateId(
              testWorkoutTemplate.id,
            );
        expect(allTemplates, isEmpty);
      });

      test(
        'should handle batch insert with duplicate ID among valid templates',
        () async {
          await exerciseTemplateDao.insert(testExerciseTemplate);

          final templates = [
            ExerciseTemplateModel.forTest(
              workoutTemplateId: testWorkoutTemplate.id,
              order: 1,
            ),
            testExerciseTemplate, // Duplicate
            ExerciseTemplateModel.forTest(
              workoutTemplateId: testWorkoutTemplate.id,
              order: 2,
            ),
          ];

          expect(
            () async => await exerciseTemplateDao.batchInsert(templates),
            throwsA(isA<DatabaseException>()),
          );

          final allTemplates = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );
          expect(allTemplates.length, equals(1));
          expectExerciseTemplatesEqual(
            allTemplates.first,
            testExerciseTemplate,
          );
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await exerciseTemplateDao.insert(testExerciseTemplate);
      });

      test('should retrieve exercise template by ID correctly', () async {
        final retrieved = await exerciseTemplateDao.getById(
          testExerciseTemplate.id,
        );
        expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
      });

      test(
        'should return null when exercise template does not exist',
        () async {
          final nonExistent = await exerciseTemplateDao.getById('99999');

          expect(nonExistent, isNull);
        },
      );

      test(
        'should retrieve all exercise templates for a workout template',
        () async {
          final template2 = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 2,
          );
          final template3 = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 3,
          );

          await exerciseTemplateDao.insert(template2);
          await exerciseTemplateDao.insert(template3);

          final allTemplates = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(
                testWorkoutTemplate.id,
              );

          expect(allTemplates.length, equals(3));
          expect(allTemplates, everyElement(isA<ExerciseTemplateModel>()));
        },
      );

      test(
        'should return empty list when workout template has no exercises',
        () async {
          final emptyTemplate = WorkoutTemplateModel.forTest(
            title: 'Empty Template',
          );
          await workoutTemplateDao.insert(emptyTemplate);

          final templates = await exerciseTemplateDao
              .getAllExerciseTemplatesWithWorkoutTemplateId(emptyTemplate.id);

          expect(templates, isEmpty);
          expect(templates, isA<List<ExerciseTemplateModel>>());
        },
      );
    });

    group('Update Operations', () {
      setUp(() async {
        await exerciseTemplateDao.insert(testExerciseTemplate);
      });

      test('should update existing exercise template successfully', () async {
        final updatedTemplate = testExerciseTemplate.copyWith(order: 5);

        final rowsAffected = await exerciseTemplateDao.update(updatedTemplate);

        expect(rowsAffected, equals(1));

        final retrieved = await exerciseTemplateDao.getById(
          testExerciseTemplate.id,
        );
        expectExerciseTemplatesEqual(retrieved, updatedTemplate);
      });

      test(
        'should return 0 when trying to update non-existent template',
        () async {
          final nonExistentTemplate = ExerciseTemplateModel(
            id: '99999',
            workoutTemplateId: testWorkoutTemplate.id,
            order: 1,
          );

          final rowsAffected = await exerciseTemplateDao.update(
            nonExistentTemplate,
          );

          expect(rowsAffected, equals(0));
        },
      );
    });

    group('Batch Update Operations', () {
      test(
        'should batch update multiple exercise templates correctly',
        () async {
          final templates = [
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

          await exerciseTemplateDao.batchInsert(templates);

          final updatedTemplates = [
            templates[0].copyWith(order: 10),
            templates[1].copyWith(order: 20),
            templates[2].copyWith(order: 30),
          ];

          await exerciseTemplateDao.batchUpdate(updatedTemplates);

          final retrieved1 = await exerciseTemplateDao.getById(templates[0].id);
          final retrieved2 = await exerciseTemplateDao.getById(templates[1].id);
          final retrieved3 = await exerciseTemplateDao.getById(templates[2].id);

          expect(retrieved1!.order, equals(10));
          expect(retrieved2!.order, equals(20));
          expect(retrieved3!.order, equals(30));
        },
      );

      test('should handle empty list gracefully in batch update', () async {
        await exerciseTemplateDao.insert(testExerciseTemplate);

        await exerciseTemplateDao.batchUpdate([]);

        final retrieved = await exerciseTemplateDao.getById(
          testExerciseTemplate.id,
        );
        expectExerciseTemplatesEqual(retrieved, testExerciseTemplate);
      });
    });

    group('Delete Operations', () {
      setUp(() async {
        await exerciseTemplateDao.insert(testExerciseTemplate);
      });

      test('should delete existing exercise template successfully', () async {
        final rowsDeleted = await exerciseTemplateDao.delete(
          testExerciseTemplate.id,
        );

        expect(rowsDeleted, equals(1));

        final retrieved = await exerciseTemplateDao.getById(
          testExerciseTemplate.id,
        );
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent template',
        () async {
          final rowsDeleted = await exerciseTemplateDao.delete('99999');

          expect(rowsDeleted, equals(0));
        },
      );
    });
  });
}
