import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/exercise_dao.dart';
import 'package:lograt/data/dao/exercise_set_dao.dart';
import 'package:lograt/data/dao/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/database/seed_data.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/exercise_set_model.dart';
import 'package:lograt/data/models/workouts/exercise_type_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/data/usecases/seed_data_usecase.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SeedDataUsecase Tests', () {
    late AppDatabase testDatabase;
    late WorkoutRepository repository;
    late SeedDataUsecase seedDataUsecase;

    setUp(() async {
      testDatabase = AppDatabase.inMemory();

      final workoutDao = WorkoutDao(testDatabase);
      final exerciseDao = ExerciseDao(testDatabase);
      final exerciseTypeDao = ExerciseTypeDao(testDatabase);
      final exerciseSetDao = ExerciseSetDao(testDatabase);

      repository = WorkoutRepository(
        databaseConnection: testDatabase,
        workoutDao: workoutDao,
        exerciseDao: exerciseDao,
        exerciseTypeDao: exerciseTypeDao,
        exerciseSetDao: exerciseSetDao,
      );

      seedDataUsecase = SeedDataUsecase(repository);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test('should seed database with expected counts and content', () async {
      // Calculate expected counts from seed data
      final expectedWorkoutCount = SeedData.sampleWorkouts.length;

      int expectedExerciseCount = 0;
      int expectedExerciseSetCount = 0;
      Set<String> uniqueExerciseTypeNames = {};

      for (final workout in SeedData.sampleWorkouts) {
        expectedExerciseCount += workout.exercises.length;
        for (final exercise in workout.exercises) {
          expectedExerciseSetCount += exercise.sets.length;
          if (exercise.exerciseType != null) {
            uniqueExerciseTypeNames.add(exercise.exerciseType!.name);
          }
        }
      }

      final expectedExerciseTypeCount = uniqueExerciseTypeNames.length;

      // Seed the database
      await seedDataUsecase.call();

      // Verify counts
      final workoutCount = await repository.count(workoutsTable);
      final exerciseCount = await repository.count(exercisesTable);
      final exerciseTypeCount = await repository.count(exerciseTypesTable);
      final exerciseSetCount = await repository.count(setsTable);

      expect(workoutCount, equals(expectedWorkoutCount));
      expect(exerciseCount, equals(expectedExerciseCount));
      expect(exerciseTypeCount, equals(expectedExerciseTypeCount));
      expect(exerciseSetCount, equals(expectedExerciseSetCount));

      // Verify content - fetch all workouts with full details
      final seededWorkouts = await repository.getWorkoutSummaries(
        limit: expectedWorkoutCount,
      );

      expect(seededWorkouts.length, equals(expectedWorkoutCount));

      // For each expected workout, find and verify its seeded counterpart
      for (final expectedWorkout in SeedData.sampleWorkouts) {
        // Find the seeded workout that matches by title and date
        final seededSummary = seededWorkouts.firstWhere(
          (w) =>
              w.title == expectedWorkout.title &&
              w.date.millisecondsSinceEpoch ==
                  expectedWorkout.date.millisecondsSinceEpoch,
        );

        // Verify workout summary fields
        expect(seededSummary.notes, equals(expectedWorkout.notes));

        // Fetch full workout details
        final seededWorkout = await repository.getFullWorkoutDetails(
          seededSummary.id,
        );

        // Verify exercise count
        expect(
          seededWorkout.exercises.length,
          equals(expectedWorkout.exercises.length),
        );

        // Verify each exercise
        for (int j = 0; j < seededWorkout.exercises.length; j++) {
          final seededExercise = seededWorkout.exercises[j];
          final expectedExercise = expectedWorkout.exercises[j];

          expect(seededExercise.order, equals(expectedExercise.order));
          expect(seededExercise.notes, equals(expectedExercise.notes));

          // Verify exercise type
          if (expectedExercise.exerciseType != null) {
            expect(seededExercise.exerciseType, isNotNull);
            expect(
              seededExercise.exerciseType!.name,
              equals(expectedExercise.exerciseType!.name),
            );
            expect(
              seededExercise.exerciseType!.description,
              equals(expectedExercise.exerciseType!.description),
            );
          } else {
            expect(seededExercise.exerciseType, isNull);
          }

          // Verify sets count
          expect(
            seededExercise.sets.length,
            equals(expectedExercise.sets.length),
          );

          // Verify each set
          for (int k = 0; k < seededExercise.sets.length; k++) {
            final seededSet = seededExercise.sets[k];
            final expectedSet = expectedExercise.sets[k];

            expect(seededSet.order, equals(expectedSet.order));
            expect(seededSet.setType, equals(expectedSet.setType));
            expect(seededSet.weight, equals(expectedSet.weight));
            expect(seededSet.units, equals(expectedSet.units));
            expect(seededSet.reps, equals(expectedSet.reps));
            expect(
              seededSet.restTime?.inSeconds,
              equals(expectedSet.restTime?.inSeconds),
            );
          }
        }
      }
    });
  });
}
