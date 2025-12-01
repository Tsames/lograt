import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WorkoutTemplateDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutTemplateDao workoutTemplateDao;
    late WorkoutTemplateModel testTemplate;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      testTemplate = WorkoutTemplateModel.forTest(
        title: 'Push Day',
        description: 'Chest, shoulders, and triceps',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new workout template correctly', () async {
        await workoutTemplateDao.insert(testTemplate);

        final retrieved = await workoutTemplateDao.getById(testTemplate.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(testTemplate.id));
        expect(retrieved.date, equals(testTemplate.date));
        expect(retrieved.title, equals(testTemplate.title));
        expect(retrieved.description, equals(testTemplate.description));
      });

      test('should handle inserting template with minimal data', () async {
        final minimalTemplate = WorkoutTemplateModel.forTest();

        await workoutTemplateDao.insert(minimalTemplate);

        final retrieved = await workoutTemplateDao.getById(minimalTemplate.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(minimalTemplate.id));
        expect(retrieved.date, equals(minimalTemplate.date));
        expect(retrieved.title, isNull);
        expect(retrieved.description, isNull);
      });
    });

    group('Read Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testTemplate);
      });

      test('should retrieve workout template by ID correctly', () async {
        final retrieved = await workoutTemplateDao.getById(testTemplate.id);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<WorkoutTemplateModel>());
        expect(retrieved!.id, equals(testTemplate.id));
        expect(retrieved.date, equals(testTemplate.date));
        expect(retrieved.title, equals('Push Day'));
        expect(retrieved.description, equals('Chest, shoulders, and triceps'));
      });

      test('should return null when template does not exist', () async {
        final nonExistent = await workoutTemplateDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve all templates ordered by date DESC', () async {
        final template2 = WorkoutTemplateModel.forTest(
          date: DateTime.now().add(const Duration(days: 1)),
          title: 'Pull Day',
          description: 'Back and biceps',
        );
        final template3 = WorkoutTemplateModel.forTest(
          date: DateTime.now().add(const Duration(days: 2)),
          title: 'Leg Day',
          description: 'Legs',
        );

        await workoutTemplateDao.insert(template2);
        await workoutTemplateDao.insert(template3);

        final allTemplates = await workoutTemplateDao.getTemplateSummaries();

        expect(allTemplates.length, equals(3));
        expect(allTemplates, everyElement(isA<WorkoutTemplateModel>()));
        expect(allTemplates[0].id, equals(template3.id));
        expect(allTemplates[1].id, equals(template2.id));
        expect(allTemplates[2].id, equals(testTemplate.id));
      });

      test('should return empty list when no templates exist', () async {
        await workoutTemplateDao.clearTable(null);
        final allTemplates = await workoutTemplateDao.getTemplateSummaries();

        expect(allTemplates, isEmpty);
        expect(allTemplates, isA<List<WorkoutTemplateModel>>());
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testTemplate);
      });

      test('should update existing template successfully', () async {
        final updatedTemplate = testTemplate.copyWith(
          title: 'Upper Body Push',
          description: 'Modified push workout',
        );

        final rowsAffected = await workoutTemplateDao.update(updatedTemplate);

        expect(rowsAffected, equals(1));

        final retrieved = await workoutTemplateDao.getById(testTemplate.id);
        expect(retrieved!.title, equals('Upper Body Push'));
        expect(retrieved.description, equals('Modified push workout'));
      });

      test(
        'should return 0 when trying to update non-existent template',
        () async {
          final nonExistentTemplate = WorkoutTemplateModel(
            id: '99999',
            title: 'Ghost Template',
            date: DateTime.now(),
          );

          final rowsAffected = await workoutTemplateDao.update(
            nonExistentTemplate,
          );

          expect(rowsAffected, equals(0));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await workoutTemplateDao.insert(testTemplate);
      });

      test('should delete existing template successfully', () async {
        final rowsDeleted = await workoutTemplateDao.delete(testTemplate.id);

        expect(rowsDeleted, equals(1));

        final retrieved = await workoutTemplateDao.getById(testTemplate.id);
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent template',
        () async {
          final rowsDeleted = await workoutTemplateDao.delete('99999');

          expect(rowsDeleted, equals(0));
        },
      );
    });
  });
}
