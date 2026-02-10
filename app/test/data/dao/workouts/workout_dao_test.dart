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

  void expectWorkoutsEqual(WorkoutModel? actual, WorkoutModel expected) {
    expect(actual, isNotNull, reason: 'Expected workout to exist but got null');

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    expect(
      actualMap[WorkoutModel.idFieldName],
      equals(expectedMap[WorkoutModel.idFieldName]),
      reason: 'Field "${WorkoutModel.idFieldName}" does not match',
    );

    expect(
      actualMap[WorkoutModel.dateFieldName],
      equals(expectedMap[WorkoutModel.dateFieldName]),
      reason: 'Field "${WorkoutModel.dateFieldName}" does not match',
    );

    expect(
      actualMap[WorkoutModel.titleFieldName],
      equals(expectedMap[WorkoutModel.titleFieldName]),
      reason: 'Field "${WorkoutModel.titleFieldName}" does not match',
    );

    expect(
      actualMap[WorkoutModel.templateIdFieldName],
      equals(expectedMap[WorkoutModel.templateIdFieldName]),
      reason: 'Field "${WorkoutModel.templateIdFieldName}" does not match',
    );

    expect(
      actualMap[WorkoutModel.notesFieldName],
      equals(expectedMap[WorkoutModel.notesFieldName]),
      reason: 'Field "${WorkoutModel.notesFieldName}" does not match',
    );
  }

  group('WorkoutDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutDao workoutDao;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutDao = WorkoutDao(testDatabase);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('getAllPaginatedOrderedByDate', () {
      test('should retrieve all workouts ordered by date descending', () async {
        final workout1 = WorkoutModel(
          id: 'workout-1',
          date: DateTime(2024, 1, 1),
          title: 'Old Workout',
        );
        final workout2 = WorkoutModel(
          id: 'workout-2',
          date: DateTime(2024, 6, 1),
          title: 'Mid Workout',
        );
        final workout3 = WorkoutModel(
          id: 'workout-3',
          date: DateTime(2024, 12, 1),
          title: 'Recent Workout',
        );

        await workoutDao.insert(workout1);
        await workoutDao.insert(workout2);
        await workoutDao.insert(workout3);

        final allWorkouts = await workoutDao.getAllPaginatedOrderedByDate();

        expect(allWorkouts.length, equals(3));

        // Verify descending order (most recent first)
        expectWorkoutsEqual(allWorkouts[0], workout3);
        expectWorkoutsEqual(allWorkouts[1], workout2);
        expectWorkoutsEqual(allWorkouts[2], workout1);
      });

      test('should return empty list when no workouts exist', () async {
        final workouts = await workoutDao.getAllPaginatedOrderedByDate();

        expect(workouts, isEmpty);
        expect(workouts, isA<List<WorkoutModel>>());
      });

      test('should respect pagination limit', () async {
        final workouts = [
          WorkoutModel(
            id: 'w1',
            date: DateTime(2024, 1, 1),
            title: 'Workout 1',
          ),
          WorkoutModel(
            id: 'w2',
            date: DateTime(2024, 2, 1),
            title: 'Workout 2',
          ),
          WorkoutModel(
            id: 'w3',
            date: DateTime(2024, 3, 1),
            title: 'Workout 3',
          ),
          WorkoutModel(
            id: 'w4',
            date: DateTime(2024, 4, 1),
            title: 'Workout 4',
          ),
        ];

        await workoutDao.batchInsert(workouts);

        final limited = await workoutDao.getAllPaginatedOrderedByDate(limit: 2);

        expect(limited.length, equals(2));
        expectWorkoutsEqual(limited[0], workouts[3]); // Most recent
        expectWorkoutsEqual(limited[1], workouts[2]);
      });

      test('should respect pagination offset', () async {
        final workouts = [
          WorkoutModel(
            id: 'w1',
            date: DateTime(2024, 1, 1),
            title: 'Workout 1',
          ),
          WorkoutModel(
            id: 'w2',
            date: DateTime(2024, 2, 1),
            title: 'Workout 2',
          ),
          WorkoutModel(
            id: 'w3',
            date: DateTime(2024, 3, 1),
            title: 'Workout 3',
          ),
          WorkoutModel(
            id: 'w4',
            date: DateTime(2024, 4, 1),
            title: 'Workout 4',
          ),
        ];

        await workoutDao.batchInsert(workouts);

        final page2 = await workoutDao.getAllPaginatedOrderedByDate(
          limit: 2,
          offset: 2,
        );

        expect(page2.length, equals(2));
        expectWorkoutsEqual(page2[0], workouts[1]); // Third most recent
        expectWorkoutsEqual(page2[1], workouts[0]); // Oldest
      });
    });

    group('Foreign Key Constraints', () {
      late WorkoutTemplateDao workoutTemplateDao;

      setUp(() {
        workoutTemplateDao = WorkoutTemplateDao(testDatabase);
      });

      test(
        'should SET NULL on workout templateId when template is deleted',
        () async {
          final template = WorkoutTemplateModel.forTest(title: 'Test Template');
          await workoutTemplateDao.insert(template);

          final workoutWithTemplate = WorkoutModel.forTest(
            title: 'Workout from template',
            templateId: template.id,
          );
          await workoutDao.insert(workoutWithTemplate);

          // Verify workout has template
          final beforeDelete = await workoutDao.getById(workoutWithTemplate.id);
          expect(beforeDelete!.templateId, equals(template.id));

          // Delete the template
          await workoutTemplateDao.delete(template.id);

          // Workout should still exist but templateId should be null
          final afterDelete = await workoutDao.getById(workoutWithTemplate.id);
          expect(afterDelete, isNotNull);
          expect(afterDelete!.templateId, isNull);
        },
      );

      test(
        'should SET NULL on all workouts when shared template is deleted',
        () async {
          final template = WorkoutTemplateModel.forTest(
            title: 'Shared Template',
          );
          await workoutTemplateDao.insert(template);

          final workout1 = WorkoutModel.forTest(
            title: 'Workout 1',
            templateId: template.id,
          );
          final workout2 = WorkoutModel.forTest(
            title: 'Workout 2',
            templateId: template.id,
          );

          await workoutDao.insert(workout1);
          await workoutDao.insert(workout2);

          // Delete the shared template
          await workoutTemplateDao.delete(template.id);

          // Both workouts should have null templateId
          final retrieved1 = await workoutDao.getById(workout1.id);
          final retrieved2 = await workoutDao.getById(workout2.id);

          expect(retrieved1!.templateId, isNull);
          expect(retrieved2!.templateId, isNull);
        },
      );
    });
  });
}
