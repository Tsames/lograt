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
    expect(actual, isNotNull);

    final actualMap = actual!.toMap();
    final expectedMap = expected.toMap();

    for (final field in WorkoutFields.values) {
      expect(
        actualMap[field],
        equals(expectedMap[field]),
        reason: 'Field "$field" does not match',
      );
    }
  }

  group('WorkoutDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutDao workoutDao;
    late WorkoutTemplateDao workoutTemplateDao;
    late WorkoutModel testWorkout;
    late WorkoutTemplateModel testTemplate;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutDao = WorkoutDao(testDatabase);
      workoutTemplateDao = WorkoutTemplateDao(testDatabase);

      testTemplate = WorkoutTemplateModel.forTest(
        title: 'Chest and Shoulders Workout',
        description: 'My typical chest and shoulders workout',
      );
      testWorkout = WorkoutModel.forTest(
        templateId: testTemplate.id,
        title: 'Push Day',
        notes: 'Chest and shoulders',
      );

      await workoutTemplateDao.insert(testTemplate);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new workout correctly', () async {
        await workoutDao.insert(testWorkout);

        final retrieved = await workoutDao.getById(testWorkout.id);
        expectWorkoutsEqual(retrieved, testWorkout);
      });

      test('should handle inserting workout with minimal data', () async {
        final minimalWorkout = WorkoutModel.forTest();

        await workoutDao.insert(minimalWorkout);

        final retrieved = await workoutDao.getById(minimalWorkout.id);
        expectWorkoutsEqual(retrieved, minimalWorkout);
      });
    });

    group('Read Operations', () {
      setUp(() async {
        await workoutDao.insert(testWorkout);
      });

      test('should retrieve workout by ID correctly', () async {
        final retrieved = await workoutDao.getById(testWorkout.id);
        expectWorkoutsEqual(retrieved, testWorkout);
      });

      test('should return null when workout does not exist', () async {
        final nonExistent = await workoutDao.getById('99999');

        expect(nonExistent, isNull);
      });

      test('should retrieve all workouts ordered by date DESC', () async {
        final workout2 = WorkoutModel.forTest(
          date: testWorkout.date.add(Duration(days: 1)),
          title: 'Pull Day',
          notes: 'Back and biceps',
        );
        final workout3 = WorkoutModel.forTest(
          date: testWorkout.date.add(Duration(days: 2)),
          title: 'Leg Day',
          notes: 'Squats and deadlifts',
        );

        await workoutDao.insert(workout2);
        await workoutDao.insert(workout3);

        final allWorkouts = await workoutDao
            .getListOfWorkoutsOrderedByCreationDate();

        expect(allWorkouts.length, equals(3));
        expect(allWorkouts, everyElement(isA<WorkoutModel>()));
        expectWorkoutsEqual(allWorkouts[0], workout3);
        expectWorkoutsEqual(allWorkouts[1], workout2);
        expectWorkoutsEqual(allWorkouts[2], testWorkout);
      });

      test('should return empty list when no workouts exist', () async {
        await workoutDao.clearTable();
        final allWorkouts = await workoutDao
            .getListOfWorkoutsOrderedByCreationDate();

        expect(allWorkouts, isEmpty);
        expect(allWorkouts, isA<List<WorkoutModel>>());
      });
    });

    group('Update Operations', () {
      setUp(() async {
        await workoutDao.insert(testWorkout);
      });

      test('should update existing workout successfully', () async {
        final updatedWorkout = testWorkout.copyWith(
          title: 'Upper Body Push',
          notes: 'Modified workout plan',
        );

        final rowsAffected = await workoutDao.update(updatedWorkout);

        expect(rowsAffected, equals(1));

        final retrieved = await workoutDao.getById(testWorkout.id);
        expectWorkoutsEqual(retrieved, updatedWorkout);
      });

      test(
        'should return 0 when trying to update non-existent workout',
        () async {
          final nonExistentWorkout = WorkoutModel(
            id: '99999',
            date: DateTime.now(),
            title: 'Ghost Workout',
          );

          final rowsAffected = await workoutDao.update(nonExistentWorkout);

          expect(rowsAffected, equals(0));
        },
      );
    });

    group('Delete Operations', () {
      setUp(() async {
        await workoutDao.insert(testWorkout);
      });

      test('should delete existing workout successfully', () async {
        final rowsDeleted = await workoutDao.delete(testWorkout.id);

        expect(rowsDeleted, equals(1));

        final retrieved = await workoutDao.getById(testWorkout.id);
        expect(retrieved, isNull);
      });

      test(
        'should return 0 when trying to delete non-existent workout',
        () async {
          final rowsDeleted = await workoutDao.delete('99999');

          expect(rowsDeleted, equals(0));
        },
      );
    });
  });
}
