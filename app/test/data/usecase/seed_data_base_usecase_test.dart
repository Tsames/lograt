import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_exercise_type_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_group_to_workout_template_dao.dart';
import 'package:lograt/data/dao/muscle_group/muscle_groups_dao.dart';
import 'package:lograt/data/dao/templates/exercise_set_template_dao.dart';
import 'package:lograt/data/dao/templates/exercise_template_dao.dart';
import 'package:lograt/data/dao/templates/workout_template_dao.dart';
import 'package:lograt/data/dao/workout/exercise_dao.dart';
import 'package:lograt/data/dao/workout/exercise_set_dao.dart';
import 'package:lograt/data/dao/workout/exercise_type_dao.dart';
import 'package:lograt/data/dao/workout/workout_dao.dart';
import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/database/seed_data.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_exercise_type_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_model.dart';
import 'package:lograt/data/models/muscle_group/muscle_group_to_workout_template_model.dart';
import 'package:lograt/data/models/templates/exercise_set_template_model.dart';
import 'package:lograt/data/models/templates/exercise_template_model.dart';
import 'package:lograt/data/models/templates/workout_template_model.dart';
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
      final workoutTemplateDao = WorkoutTemplateDao(testDatabase);
      final exerciseTemplateDao = ExerciseTemplateDao(testDatabase);
      final exerciseSetTemplateDao = ExerciseSetTemplateDao(testDatabase);
      final muscleGroupDao = MuscleGroupDao(testDatabase);
      final muscleGroupToWorkoutDao = MuscleGroupToWorkoutDao(testDatabase);
      final muscleGroupToWorkoutTemplateDao = MuscleGroupToWorkoutTemplateDao(
        testDatabase,
      );
      final muscleGroupToExerciseTypeDao = MuscleGroupToExerciseTypeDao(
        testDatabase,
      );

      repository = WorkoutRepository(
        databaseConnection: testDatabase,
        workoutDao: workoutDao,
        exerciseDao: exerciseDao,
        exerciseTypeDao: exerciseTypeDao,
        exerciseSetDao: exerciseSetDao,
        workoutTemplateDao: workoutTemplateDao,
        exerciseTemplateDao: exerciseTemplateDao,
        exerciseSetTemplateDao: exerciseSetTemplateDao,
        muscleGroupDao: muscleGroupDao,
        muscleGroupToWorkoutDao: muscleGroupToWorkoutDao,
        muscleGroupToWorkoutTemplateDao: muscleGroupToWorkoutTemplateDao,
        muscleGroupToExerciseTypeDao: muscleGroupToExerciseTypeDao,
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
      Set<ExerciseType> uniqueExerciseTypes = {};

      Set<WorkoutTemplate> uniqueWorkoutTemplates = {};
      int expectedExerciseTemplateCount = 0;
      int expectedExerciseSetTemplateCount = 0;

      Set<String> uniqueMuscleGroupLabels = {};
      int expectedMuscleGroupToWorkoutCount = 0;
      int expectedMuscleGroupToWorkoutTemplateCount = 0;
      int expectedMuscleGroupToExerciseTypeCount = 0;

      for (final workout in SeedData.sampleWorkouts) {
        expectedExerciseCount += workout.exercises.length;
        for (final exercise in workout.exercises) {
          expectedExerciseSetCount += exercise.sets.length;
          if (exercise.exerciseType != null) {
            uniqueExerciseTypes.add(exercise.exerciseType!);
          }
        }

        expectedMuscleGroupToWorkoutCount += workout.muscleGroups.length;
        for (final muscleGroup in workout.muscleGroups) {
          uniqueMuscleGroupLabels.add(muscleGroup.label);
        }

        if (workout.template != null) {
          uniqueWorkoutTemplates.add(workout.template!);
        }
      }

      for (final workoutTemplate in uniqueWorkoutTemplates) {
        expectedExerciseTemplateCount +=
            workoutTemplate.exerciseTemplates.length;
        for (final exerciseTemplate in workoutTemplate.exerciseTemplates) {
          if (exerciseTemplate.exerciseType != null) {
            uniqueExerciseTypes.add(exerciseTemplate.exerciseType!);
          }
          expectedExerciseSetTemplateCount +=
              exerciseTemplate.setTemplates.length;
        }
        if (workoutTemplate.muscleGroups.isNotEmpty) {
          expectedMuscleGroupToWorkoutTemplateCount +=
              workoutTemplate.muscleGroups.length;
          for (final muscleGroup in workoutTemplate.muscleGroups) {
            uniqueMuscleGroupLabels.add(muscleGroup.label);
          }
        }
      }

      for (final exerciseType in uniqueExerciseTypes) {
        if (exerciseType.muscleGroups.isNotEmpty) {
          expectedMuscleGroupToExerciseTypeCount +=
              exerciseType.muscleGroups.length;
        }
      }

      final expectedExerciseTypeCount = uniqueExerciseTypes.length;
      final expectedMuscleGroupCount = uniqueMuscleGroupLabels.length;
      final expectedWorkoutTemplateCount = uniqueWorkoutTemplates.length;

      // Seed the database
      await seedDataUsecase.call();

      // Verify counts
      final workoutCount = await repository.count(WorkoutModel.tableName);
      final exerciseCount = await repository.count(ExerciseModel.tableName);
      final exerciseTypeCount = await repository.count(
        ExerciseTypeModel.tableName,
      );
      final exerciseSetCount = await repository.count(
        ExerciseSetModel.tableName,
      );

      final workoutTemplateCount = await repository.count(
        WorkoutTemplateModel.tableName,
      );
      final exerciseTemplateCount = await repository.count(
        ExerciseTemplateModel.tableName,
      );
      final exerciseSetTemplateCount = await repository.count(
        ExerciseSetTemplateModel.tableName,
      );

      final muscleGroupCount = await repository.count(
        MuscleGroupModel.tableName,
      );
      final muscleGroupToWorkoutCount = await repository.count(
        MuscleGroupToWorkoutModel.tableName,
      );
      final muscleGroupToWorkoutTemplateCount = await repository.count(
        MuscleGroupToWorkoutTemplateModel.tableName,
      );
      final muscleGroupToExerciseTypeCount = await repository.count(
        MuscleGroupToExerciseTypeModel.tableName,
      );

      expect(workoutCount, equals(expectedWorkoutCount));
      expect(exerciseCount, equals(expectedExerciseCount));
      expect(exerciseTypeCount, equals(expectedExerciseTypeCount));
      expect(exerciseSetCount, equals(expectedExerciseSetCount));

      expect(workoutTemplateCount, equals(expectedWorkoutTemplateCount));
      expect(exerciseTemplateCount, equals(expectedExerciseTemplateCount));
      expect(
        exerciseSetTemplateCount,
        equals(expectedExerciseSetTemplateCount),
      );

      expect(muscleGroupCount, equals(expectedMuscleGroupCount));
      expect(
        muscleGroupToWorkoutCount,
        equals(expectedMuscleGroupToWorkoutCount),
      );
      expect(
        muscleGroupToWorkoutTemplateCount,
        equals(expectedMuscleGroupToWorkoutTemplateCount),
      );
      expect(
        muscleGroupToExerciseTypeCount,
        equals(expectedMuscleGroupToExerciseTypeCount),
      );

      // Verify content - fetch all workouts with full details
      final seededWorkouts = await repository
          .getPaginatedSortedWorkoutSummaries(limit: expectedWorkoutCount);

      expect(seededWorkouts.length, equals(expectedWorkoutCount));

      // For each expected workout, find and verify its seeded counterpart
      for (final expectedWorkout in SeedData.sampleWorkouts) {
        final seededSummary = seededWorkouts.firstWhere(
          (w) => w.id == expectedWorkout.id,
        );

        // Verify workout summary fields
        expect(seededSummary.notes, equals(expectedWorkout.notes));

        // Verify template
        if (expectedWorkout.template != null) {
          expect(seededSummary.template, isNotNull);
          expect(
            seededSummary.template!.title,
            equals(expectedWorkout.template!.title),
          );
        } else {
          expect(seededSummary.template, isNull);
        }

        // Verify muscle groups
        expect(
          seededSummary.muscleGroups.length,
          equals(expectedWorkout.muscleGroups.length),
        );
        expect(
          seededSummary.muscleGroups.map((mg) => mg.label),
          containsAll(expectedWorkout.muscleGroups.map((mg) => mg.label)),
        );

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
