import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/database/dao/workout_dao.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WorkoutDao Tests', () {
    late AppDatabase database;
    late WorkoutDao dao;

    setUp(() async {
      database = AppDatabase.inMemory();

      dao = WorkoutDao(database);
    });

    tearDown(() async {
      final db = await database.database;
      await db.close();
    });

    test('should insert and retrieve workout', () async {
      final workout = WorkoutModel(name: 'Test Workout', createdOn: DateTime.now());

      await dao.insert(workout);
      final workouts = await dao.getWorkouts();

      expect(workouts.length, equals(1));
      expect(workouts.first.name, equals('Test Workout'));
    });

    test('should handle multiple workouts', () async {
      final workout1 = WorkoutModel(name: 'Workout 1', createdOn: DateTime.now());
      final workout2 = WorkoutModel(name: 'Workout 2', createdOn: DateTime.now());

      await dao.insert(workout1);
      await dao.insert(workout2);

      final workouts = await dao.getWorkouts();

      expect(workouts.length, equals(2));
    });

    test('should delete a workout after inserting it', () async {
      final workout = WorkoutModel(name: 'Delete Test', createdOn: DateTime.now());

      await dao.insert(workout);

      var workouts = await dao.getWorkouts();
      expect(workouts.length, equals(1));
      expect(workouts.first.name, equals('Delete Test'));

      final workoutId = workouts.first.id;
      await dao.delete(workoutId!);

      workouts = await dao.getWorkouts();
      expect(workouts.length, equals(0));
      expect(workouts, isEmpty);
    });

    test('should update a workout', () async {
      final workout = WorkoutModel(name: 'Update Test', createdOn: DateTime.now());
      await dao.insert(workout);

      var workouts = await dao.getWorkouts();
      expect(workouts.length, equals(1));

      final updatedWorkout = WorkoutModel(
        id: workouts.first.id,
        name: 'Updated Workout',
        createdOn: workouts.first.createdOn,
      );

      await dao.update(updatedWorkout);

      workouts = await dao.getWorkouts();
      expect(workouts.length, equals(1));
      expect(workouts.first.name, equals('Updated Workout'));
      expect(workouts.first.id, equals(updatedWorkout.id));
    });

    test('should clear all workouts from table', () async {
      final workout1 = WorkoutModel(name: 'Workout 1', createdOn: DateTime.now());
      final workout2 = WorkoutModel(name: 'Workout 2', createdOn: DateTime.now());
      final workout3 = WorkoutModel(name: 'Workout 3', createdOn: DateTime.now());

      await dao.insert(workout1);
      await dao.insert(workout2);
      await dao.insert(workout3);

      var workouts = await dao.getWorkouts();
      expect(workouts.length, equals(3));

      await dao.clearTable();

      workouts = await dao.getWorkouts();
      expect(workouts.length, equals(0));
      expect(workouts, isEmpty);
    });
  });
}
