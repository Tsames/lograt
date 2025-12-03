import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  void expectWorkoutTemplatesEqual(
    WorkoutTemplateModel? actual,
    WorkoutTemplateModel expected,
  ) {
    expect(
      actual,
      isNotNull,
      reason: 'Expected workout template to exist but got null',
    );

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    for (final field in WorkoutTemplateFields.values) {
      expect(
        actualMap[field],
        equals(expectedMap[field]),
        reason: 'Field "$field" does not match',
      );
    }
  }

  group('WorkoutTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutTemplateDao workoutTemplateDao;
    late WorkoutTemplateModel testWorkoutTemplate;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      testWorkoutTemplate = WorkoutTemplateModel.forTest(
        title: 'Test Template',
        description: 'Test description',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new workout template correctly', () async {
        await workoutTemplateDao.insert(testWorkoutTemplate);

        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );
        expectWorkoutTemplatesEqual(retrieved, testWorkoutTemplate);
      });

      test(
        'should handle inserting workout template with minimal data',
        () async {
          final minimalWorkoutTemplate = WorkoutTemplateModel.forTest();

          await workoutTemplateDao.insert(minimalWorkoutTemplate);

          final retrieved = await workoutTemplateDao.getById(
            minimalWorkoutTemplate.id,
          );
          expectWorkoutTemplatesEqual(retrieved, minimalWorkoutTemplate);
        },
      );

      test(
        'should throw exception when inserting workout template with duplicate id',
        () async {
          final otherWorkoutTemplate = testWorkoutTemplate.copyWith(
            title: 'Different Title',
          );
          await workoutTemplateDao.insert(testWorkoutTemplate);
          expect(
            () async => await workoutTemplateDao.insert(otherWorkoutTemplate),
            throwsA(isA<Exception>()),
          );
        },
      );

      test('should handle transaction-based insert correctly', () async {
        final db = await testDatabase.database;

        await db.transaction((txn) async {
          await workoutTemplateDao.insert(testWorkoutTemplate, txn);
          final retrieved = await workoutTemplateDao.getById(
            testWorkoutTemplate.id,
            txn,
          );
          expectWorkoutTemplatesEqual(retrieved, testWorkoutTemplate);
        });

        // Verify it persisted after transaction
        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );
        expectWorkoutTemplatesEqual(retrieved, testWorkoutTemplate);
      });
    });

    group('Batch Insert Operations', () {
      test(
        'should batch insert multiple workout templates correctly',
        () async {
          final now = DateTime.now();

          final workoutTemplates = [
            WorkoutTemplateModel.forTest(title: 'Template 1'),
            WorkoutTemplateModel.forTest(
              title: 'Template 2',
              date: now.add(Duration(days: 1)),
            ),
            WorkoutTemplateModel.forTest(
              title: 'Template 3',
              date: now.add(Duration(days: 2)),
            ),
          ];

          await workoutTemplateDao.batchInsert(workoutTemplates);

          final allWorkoutTemplates = await workoutTemplateDao
              .getTemplatePaginatedOrderedByDate();
          expect(allWorkoutTemplates.length, equals(3));
          expect(
            allWorkoutTemplates,
            everyElement(isA<WorkoutTemplateModel>()),
          );

          // Verify they're sorted by date DESC (most recent first)
          expect(allWorkoutTemplates[0].title, equals('Template 3'));
          expect(allWorkoutTemplates[1].title, equals('Template 2'));
          expect(allWorkoutTemplates[2].title, equals('Template 1'));
        },
      );

      test('should handle empty list gracefully in batch insert', () async {
        await workoutTemplateDao.batchInsert([]);

        final allWorkoutTemplates = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate();
        expect(allWorkoutTemplates, isEmpty);
      });

      test(
        'should throw exception and rollback insertions when batch insert has duplicate id among valid workout templates',
        () async {
          await workoutTemplateDao.insert(testWorkoutTemplate);

          final workoutTemplates = [
            WorkoutTemplateModel.forTest(title: 'Template 1'),
            testWorkoutTemplate,
            WorkoutTemplateModel.forTest(title: 'Template 2'),
          ];

          expect(
            () async => await workoutTemplateDao.batchInsert(workoutTemplates),
            throwsA(isA<DatabaseException>()),
          );

          final allWorkoutTemplates = await workoutTemplateDao
              .getTemplatePaginatedOrderedByDate();
          expect(allWorkoutTemplates.length, equals(1));
          expectWorkoutTemplatesEqual(
            allWorkoutTemplates.first,
            testWorkoutTemplate,
          );
        },
      );
    });

    group('Read Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testWorkoutTemplate);
      });

      test('should retrieve workout template by id correctly', () async {
        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );

        expectWorkoutTemplatesEqual(retrieved, testWorkoutTemplate);
      });

      test('should return null when workout template does not exist', () async {
        final nonExistent = await workoutTemplateDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test(
        'should retrieve all workout templates ordered by date descending',
        () async {
          final template1 = WorkoutTemplateModel(
            id: 'template-1',
            date: DateTime(2024, 1, 1),
            title: 'Old Template',
          );
          final template2 = WorkoutTemplateModel(
            id: 'template-2',
            date: DateTime(2024, 6, 1),
            title: 'Mid Template',
          );
          final template3 = WorkoutTemplateModel(
            id: 'template-3',
            date: DateTime(2024, 12, 1),
            title: 'Recent Template',
          );

          await workoutTemplateDao.insert(template1);
          await workoutTemplateDao.insert(template2);
          await workoutTemplateDao.insert(template3);

          final allWorkoutTemplates = await workoutTemplateDao
              .getTemplatePaginatedOrderedByDate();

          expect(
            allWorkoutTemplates.length,
            equals(4),
          ); // Including testWorkoutTemplate
          expect(
            allWorkoutTemplates,
            everyElement(isA<WorkoutTemplateModel>()),
          );

          // Verify descending order (most recent first)
          expectWorkoutTemplatesEqual(
            allWorkoutTemplates[0],
            testWorkoutTemplate,
          );
          expectWorkoutTemplatesEqual(allWorkoutTemplates[1], template3);
          expectWorkoutTemplatesEqual(allWorkoutTemplates[2], template2);
          expectWorkoutTemplatesEqual(allWorkoutTemplates[3], template1);
        },
      );

      test(
        'should return empty list when no workout templates exist',
        () async {
          await workoutTemplateDao.delete(testWorkoutTemplate.id);

          final workoutTemplates = await workoutTemplateDao
              .getTemplatePaginatedOrderedByDate();

          expect(workoutTemplates, isEmpty);
          expect(workoutTemplates, isA<List<WorkoutTemplateModel>>());
        },
      );

      test('should respect pagination limit and offset', () async {
        final workoutTemplates = [
          WorkoutTemplateModel(
            id: 't1',
            date: DateTime(2024, 1, 1),
            title: 'Template 1',
          ),
          WorkoutTemplateModel(
            id: 't2',
            date: DateTime(2024, 2, 1),
            title: 'Template 2',
          ),
          WorkoutTemplateModel(
            id: 't3',
            date: DateTime(2024, 3, 1),
            title: 'Template 3',
          ),
          WorkoutTemplateModel(
            id: 't4',
            date: DateTime(2024, 4, 1),
            title: 'Template 4',
          ),
        ];

        await workoutTemplateDao.batchInsert(workoutTemplates);

        // Get first 2 (most recent)
        final page1 = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate(limit: 2, offset: 0);
        expect(page1.length, equals(2));
        expectWorkoutTemplatesEqual(page1[0], testWorkoutTemplate);
        expectWorkoutTemplatesEqual(page1[1], workoutTemplates[3]);

        // Get next 2
        final page2 = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate(limit: 2, offset: 2);
        expect(page2.length, equals(2));
        expectWorkoutTemplatesEqual(page2[0], workoutTemplates[2]);
        expectWorkoutTemplatesEqual(page2[1], workoutTemplates[1]);
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testWorkoutTemplate);
      });

      test('should update existing workout template successfully', () async {
        final updatedWorkoutTemplate = testWorkoutTemplate.copyWith(
          title: 'Updated Title',
          description: 'Updated description',
        );

        await workoutTemplateDao.update(updatedWorkoutTemplate);

        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );
        expectWorkoutTemplatesEqual(retrieved, updatedWorkoutTemplate);
      });

      test(
        'should throw an exception when trying to update non-existent workout template',
        () async {
          final nonExistentWorkoutTemplate = WorkoutTemplateModel(
            id: '99999',
            date: DateTime.now(),
          );

          expect(
            () async =>
                await workoutTemplateDao.update(nonExistentWorkoutTemplate),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Batch Update Operations', () {
      test(
        'should batch update multiple workout templates correctly',
        () async {
          final workoutTemplates = [
            WorkoutTemplateModel.forTest(title: 'Original 1'),
            WorkoutTemplateModel.forTest(title: 'Original 2'),
            WorkoutTemplateModel.forTest(title: 'Original 3'),
          ];

          await workoutTemplateDao.batchInsert(workoutTemplates);

          final updatedWorkoutTemplates = [
            workoutTemplates[0].copyWith(title: 'Updated 1'),
            workoutTemplates[1].copyWith(title: 'Updated 2'),
            workoutTemplates[2].copyWith(title: 'Updated 3'),
          ];

          await workoutTemplateDao.batchUpdate(updatedWorkoutTemplates);

          final retrieved1 = await workoutTemplateDao.getById(
            workoutTemplates[0].id,
          );
          final retrieved2 = await workoutTemplateDao.getById(
            workoutTemplates[1].id,
          );
          final retrieved3 = await workoutTemplateDao.getById(
            workoutTemplates[2].id,
          );

          expectWorkoutTemplatesEqual(retrieved1, updatedWorkoutTemplates[0]);
          expectWorkoutTemplatesEqual(retrieved2, updatedWorkoutTemplates[1]);
          expectWorkoutTemplatesEqual(retrieved3, updatedWorkoutTemplates[2]);
        },
      );

      test('should handle empty list gracefully in batch update', () async {
        await workoutTemplateDao.insert(testWorkoutTemplate);

        await workoutTemplateDao.batchUpdate([]);

        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );
        expectWorkoutTemplatesEqual(retrieved, testWorkoutTemplate);
      });

      test(
        'should throw exception and rollback all updates when one workout template does not exist',
        () async {
          final existingWorkoutTemplate = WorkoutTemplateModel.forTest(
            title: 'Original',
          );
          await workoutTemplateDao.insert(existingWorkoutTemplate);

          final nonExistentWorkoutTemplate = WorkoutTemplateModel(
            id: 'non-existent',
            date: DateTime.now(),
          );
          final updatedExisting = existingWorkoutTemplate.copyWith(
            title: 'Should not persist',
          );

          expect(
            () async => await workoutTemplateDao.batchUpdate([
              updatedExisting,
              nonExistentWorkoutTemplate,
            ]),
            throwsA(isA<Exception>()),
          );

          // Verify rollback - original data unchanged
          final retrieved = await workoutTemplateDao.getById(
            existingWorkoutTemplate.id,
          );
          expect(retrieved!.title, equals('Original'));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testWorkoutTemplate);
      });

      test('should delete existing workout template successfully', () async {
        await workoutTemplateDao.delete(testWorkoutTemplate.id);
        final retrieved = await workoutTemplateDao.getById(
          testWorkoutTemplate.id,
        );
        expect(retrieved, isNull);
      });

      test(
        'should throw an exception when trying to delete non-existent workout template',
        () async {
          expect(
            () async => await workoutTemplateDao.delete('99999'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Foreign Key Constraints', () {
      late WorkoutDao workoutDao;
      late ExerciseTemplateDao exerciseTemplateDao;

      setUp(() {
        workoutDao = WorkoutDao(testDatabase);
        exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
      });

      test(
        'should SET NULL on workout templateId when template is deleted',
        () async {
          await workoutTemplateDao.insert(testWorkoutTemplate);

          final workoutFromTemplate = WorkoutModel.forTest(
            title: 'Workout from template',
            templateId: testWorkoutTemplate.id,
          );
          await workoutDao.insert(workoutFromTemplate);

          // Verify workout has template
          final beforeDelete = await workoutDao.getById(workoutFromTemplate.id);
          expect(beforeDelete!.templateId, equals(testWorkoutTemplate.id));

          // Delete the template
          await workoutTemplateDao.delete(testWorkoutTemplate.id);

          // Workout should still exist but templateId should be null
          final afterDelete = await workoutDao.getById(workoutFromTemplate.id);
          expect(afterDelete, isNotNull);
          expect(afterDelete!.templateId, isNull);
        },
      );

      test(
        'should CASCADE delete exercise templates when workout template is deleted',
        () async {
          await workoutTemplateDao.insert(testWorkoutTemplate);

          final exerciseTemplate = ExerciseTemplateModel.forTest(
            workoutTemplateId: testWorkoutTemplate.id,
            order: 1,
          );
          await exerciseTemplateDao.insert(exerciseTemplate);

          // Verify exercise template exists
          final exerciseTemplateBeforeDelete = await exerciseTemplateDao
              .getById(exerciseTemplate.id);
          expect(exerciseTemplateBeforeDelete, isNotNull);

          // Delete the workout template
          await workoutTemplateDao.delete(testWorkoutTemplate.id);

          // Exercise template should be automatically deleted due to CASCADE
          final exerciseTemplateAfterDelete = await exerciseTemplateDao.getById(
            exerciseTemplate.id,
          );
          expect(exerciseTemplateAfterDelete, isNull);

          // Workout template should be deleted
          final workoutTemplateAfterDelete = await workoutTemplateDao.getById(
            testWorkoutTemplate.id,
          );
          expect(workoutTemplateAfterDelete, isNull);
        },
      );
    });
  });
}
