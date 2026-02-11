import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
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

    expect(
      actual!.id,
      equals(expected.id),
      reason: 'Field "id" does not match',
    );
    expect(
      actual.date,
      equals(expected.date),
      reason: 'Field "date" does not match',
    );
    expect(
      actual.title,
      equals(expected.title),
      reason: 'Field "title" does not match',
    );
    expect(
      actual.description,
      equals(expected.description),
      reason: 'Field "description" does not match',
    );
  }

  group('WorkoutTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutTemplateDao workoutTemplateDao;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getWorkoutTemplatesByIds', () {
      test('should retrieve multiple workout templates by ids', () async {
        final templates = [
          WorkoutTemplateModel.forTest(title: 'Template 1'),
          WorkoutTemplateModel.forTest(title: 'Template 2'),
          WorkoutTemplateModel.forTest(title: 'Template 3'),
        ];

        await workoutTemplateDao.batchInsert(templates);

        final retrieved = await workoutTemplateDao.getWorkoutTemplatesByIds([
          templates[0].id,
          templates[2].id,
        ]);

        expect(retrieved.length, equals(2));
      });

      test('should return empty list when no ids match', () async {
        final template = WorkoutTemplateModel.forTest(title: 'Template');
        await workoutTemplateDao.insert(template);

        final retrieved = await workoutTemplateDao.getWorkoutTemplatesByIds([
          'non-existent-id',
        ]);

        expect(retrieved, isEmpty);
      });

      test('should throw exception when given empty list', () async {
        expect(
          () async => await workoutTemplateDao.getWorkoutTemplatesByIds([]),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTemplatePaginatedOrderedByDate', () {
      test(
        'should retrieve all templates ordered by date descending',
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

          final allTemplates = await workoutTemplateDao
              .getTemplatePaginatedOrderedByDate();

          expect(allTemplates.length, equals(3));

          // Verify descending order (most recent first)
          expectWorkoutTemplatesEqual(allTemplates[0], template3);
          expectWorkoutTemplatesEqual(allTemplates[1], template2);
          expectWorkoutTemplatesEqual(allTemplates[2], template1);
        },
      );

      test('should return empty list when no templates exist', () async {
        final templates = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate();

        expect(templates, isEmpty);
        expect(templates, isA<List<WorkoutTemplateModel>>());
      });

      test('should respect pagination limit', () async {
        final templates = [
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

        await workoutTemplateDao.batchInsert(templates);

        final limited = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate(limit: 2);

        expect(limited.length, equals(2));
        expectWorkoutTemplatesEqual(limited[0], templates[3]); // Most recent
        expectWorkoutTemplatesEqual(limited[1], templates[2]);
      });

      test('should respect pagination offset', () async {
        final templates = [
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

        await workoutTemplateDao.batchInsert(templates);

        final page2 = await workoutTemplateDao
            .getTemplatePaginatedOrderedByDate(limit: 2, offset: 2);

        expect(page2.length, equals(2));
        expectWorkoutTemplatesEqual(page2[0], templates[1]);
        expectWorkoutTemplatesEqual(page2[1], templates[0]); // Oldest
      });
    });

    group('Foreign Key Constraints', () {
      late WorkoutDao workoutDao;

      setUp(() {
        workoutDao = WorkoutDao(testDatabase);
      });

      test(
        'should SET NULL on workout templateId when template is deleted',
        () async {
          final template = WorkoutTemplateModel.forTest(title: 'Test Template');
          await workoutTemplateDao.insert(template);

          final workoutFromTemplate = WorkoutModel.forTest(
            title: 'Workout from template',
            templateId: template.id,
          );
          await workoutDao.insert(workoutFromTemplate);

          // Verify workout has template
          final beforeDelete = await workoutDao.getById(workoutFromTemplate.id);
          expect(beforeDelete!.templateId, equals(template.id));

          // Delete the template
          await workoutTemplateDao.delete(template.id);

          // Workout should still exist but templateId should be null
          final afterDelete = await workoutDao.getById(workoutFromTemplate.id);
          expect(afterDelete, isNotNull);
          expect(afterDelete!.templateId, isNull);
        },
      );
    });
  });
}
