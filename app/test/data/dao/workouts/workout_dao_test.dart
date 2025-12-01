import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:lograt/util/uuidv7.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WorkoutDao Tests', () {
    late AppDatabase testDatabase;
    late WorkoutDao workoutDao;
    late WorkoutModel testWorkout;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();
      workoutDao = WorkoutDao(testDatabase);

      testWorkout = WorkoutModel.forTest(
        title: 'Push Day',
        templateId: uuidV7(),
        notes: 'Chest and shoulders',
      );
    });

    tearDown(() async {
      await testDatabase.close();
    });

    group('Insert Operations', () {
      test('should insert a new workout correctly', () async {
        await workoutDao.insert(testWorkout);

        final retrieved = await workoutDao.getById(testWorkout.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(testWorkout.id));
        expect(retrieved.date, equals(testWorkout.date));
        expect(retrieved.title, equals(testWorkout.title));
        expect(retrieved.templateId, equals(testWorkout.templateId));
        expect(retrieved.notes, equals(testWorkout.notes));
      });

      test('should handle inserting workout with minimal data', () async {
        final minimalWorkout = WorkoutModel.forTest();

        await workoutDao.insert(minimalWorkout);

        final retrieved = await workoutDao.getById(minimalWorkout.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(minimalWorkout.id));
        expect(retrieved.date, equals(minimalWorkout.date));
        expect(retrieved.title, equals(minimalWorkout.title));
        expect(retrieved.templateId, equals(minimalWorkout.templateId));
        expect(retrieved.notes, equals(minimalWorkout.notes));
      });
    });

    group('Read Operations', () {
      setUp(() async {
        await workoutDao.insert(testWorkout);
      });

      test('should retrieve workout by ID correctly', () async {
        final retrieved = await workoutDao.getById(testWorkout.id);

        expect(retrieved, isNotNull);
        expect(retrieved, isA<WorkoutModel>());
        expect(retrieved!.id, equals(testWorkout.id));
        expect(retrieved.date, equals(testWorkout.date));
        expect(retrieved.title, equals('Push Day'));
        expect(retrieved.templateId, equals(testWorkout.templateId));
        expect(retrieved.notes, equals('Chest and shoulders'));
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
        expect(allWorkouts[0].id, equals(workout3.id));
        expect(allWorkouts[1].id, equals(workout2.id));
        expect(allWorkouts[2].id, equals(testWorkout.id));
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
        expect(retrieved!.title, equals('Upper Body Push'));
        expect(retrieved.notes, equals('Modified workout plan'));
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
