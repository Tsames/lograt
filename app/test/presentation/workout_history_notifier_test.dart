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
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/repositories/workout_repository.dart';
import 'package:lograt/data/usecases/get_paginated_sorted_workouts_usecase.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';
import 'package:lograt/util/workout_history_section_header.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Workout History Notifier Tests', () {
    late AppDatabase testDatabase;
    late WorkoutRepository testRepository;
    late GetPaginatedSortedWorkoutsUsecase getPaginatedSortedWorkoutsUsecase;
    late WorkoutHistoryNotifier testNotifier;
    late DateTime now;

    setUp(() async {
      now = DateTime.now();
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

      testRepository = WorkoutRepository(
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

      getPaginatedSortedWorkoutsUsecase = GetPaginatedSortedWorkoutsUsecase(
        testRepository,
        pageSize: 10,
      );
      testNotifier = WorkoutHistoryNotifier(getPaginatedSortedWorkoutsUsecase);
    });

    tearDown(() async {
      await testDatabase.close();
    });

    test(
      'workouts older than 90 days should not be saved to notifier state',
      () async {
        final testWorkouts = [
          Workout(date: now.subtract(Duration(days: 8))),
          Workout(date: now.subtract(Duration(days: 10))),
          Workout(date: now.subtract(Duration(days: 31))),
          Workout(date: now.subtract(Duration(days: 45))),
          Workout(date: now.subtract(Duration(days: 59))),
          Workout(date: now.subtract(Duration(days: 82))),
          Workout(date: now.subtract(Duration(days: 91))),
        ];
        await testRepository.seedWorkoutData(testWorkouts);

        final results = await getPaginatedSortedWorkoutsUsecase.call(0);
        expect(results.results.length, testWorkouts.length);

        await testNotifier.loadPaginatedWorkouts();
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<Workout>()
              .length,
          testWorkouts
              .where(
                (workout) =>
                    workout.date.isAfter(now.beginningOfTheLastThreeMonths),
              )
              .length,
        );
      },
    );

    test(
      'notifier state should not include this week section header when no workouts happened in that time',
      () async {
        await testRepository.seedWorkoutData([
          Workout(date: now.subtract(Duration(days: 8))),
          Workout(date: now.subtract(Duration(days: 10))),
          Workout(date: now.subtract(Duration(days: 31))),
          Workout(date: now.subtract(Duration(days: 45))),
          Workout(date: now.subtract(Duration(days: 59))),
        ]);
        await testNotifier.loadPaginatedWorkouts();

        final headers = testNotifier.state.workoutsWithSectionHeaders
            .whereType<WorkoutHistorySectionHeader>();
        expect(
          headers.whereType<ThisWeekWorkoutHistorySectionHeader>(),
          isEmpty,
        );
        expect(testNotifier.state.hasWorkoutsThisWeekSectionHeader, false);

        expect(
          headers.whereType<InTheLastMonthWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(testNotifier.state.hasWorkoutsInLastMonthSectionHeader, true);

        expect(
          headers.whereType<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(
          testNotifier.state.hasWorkoutsInLastThreeMonthsSectionHeader,
          true,
        );
      },
    );

    test(
      'notifier state should not include in the last month section header when no workouts happened in that time',
      () async {
        await testRepository.seedWorkoutData([
          Workout(date: now.subtract(Duration(days: 2))),
          Workout(date: now.subtract(Duration(days: 35))),
        ]);
        await testNotifier.loadPaginatedWorkouts();

        final headers = testNotifier.state.workoutsWithSectionHeaders
            .whereType<WorkoutHistorySectionHeader>();
        expect(
          headers.whereType<ThisWeekWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(testNotifier.state.hasWorkoutsThisWeekSectionHeader, true);

        expect(
          headers.whereType<InTheLastMonthWorkoutHistorySectionHeader>(),
          isEmpty,
        );
        expect(testNotifier.state.hasWorkoutsInLastMonthSectionHeader, false);

        expect(
          headers.whereType<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(
          testNotifier.state.hasWorkoutsInLastThreeMonthsSectionHeader,
          true,
        );
      },
    );

    test(
      'notifier state should not include in the last three months section header when no workouts happened in that time',
      () async {
        await testRepository.seedWorkoutData([
          Workout(date: now.subtract(Duration(days: 2))),
          Workout(date: now.subtract(Duration(days: 15))),
          Workout(date: now.subtract(Duration(days: 100))),
        ]);

        await testNotifier.loadPaginatedWorkouts();

        final headers = testNotifier.state.workoutsWithSectionHeaders
            .whereType<WorkoutHistorySectionHeader>();
        expect(
          headers.whereType<ThisWeekWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(testNotifier.state.hasWorkoutsThisWeekSectionHeader, true);

        expect(
          headers.whereType<InTheLastMonthWorkoutHistorySectionHeader>(),
          isNotEmpty,
        );
        expect(testNotifier.state.hasWorkoutsInLastMonthSectionHeader, true);

        expect(
          headers.whereType<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
          isEmpty,
        );
        expect(
          testNotifier.state.hasWorkoutsInLastThreeMonthsSectionHeader,
          false,
        );
      },
    );

    test(
      'notifier state should be empty if only workouts older than 90 days exist in db',
      () async {
        await testRepository.seedWorkoutData([
          Workout(date: now.subtract(Duration(days: 100))),
          Workout(date: now.subtract(Duration(days: 120))),
        ]);

        await testNotifier.loadPaginatedWorkouts();
        expect(testNotifier.state.workoutsWithSectionHeaders, isEmpty);
      },
    );

    test('notifier state should be empty if db is empty', () async {
      await testRepository.seedWorkoutData([]);
      await testNotifier.loadPaginatedWorkouts();

      expect(testNotifier.state.workoutsWithSectionHeaders, isEmpty);
    });

    test(
      'notifier state should not have a weekly headers after this week section header',
      () async {
        await testRepository.seedWorkoutData([
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 1))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 2))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 4))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 6))),
        ]);

        await testNotifier.loadPaginatedWorkouts();

        final weekHeaders = testNotifier.state.workoutsWithSectionHeaders
            .whereType<WeekWorkoutHistorySectionHeader>();
        expect(weekHeaders, isEmpty);
      },
    );

    test(
      'notifier state should have a week header after the in the last month section header when no workouts happened this week',
      () async {
        final testWorkouts = [
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 1))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 5))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 8))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 9))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 20))),
        ];

        await testRepository.seedWorkoutData(testWorkouts);
        await testNotifier.loadPaginatedWorkouts();

        expect(testNotifier.state.workoutsWithSectionHeaders.length, 9);

        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<WeekWorkoutHistorySectionHeader>()
              .length,
          3,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[0],
          isA<InTheLastMonthWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[1],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[2],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[3],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[4],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[5],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[6],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[7],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[8],
          isA<Workout>(),
        );
      },
    );

    test(
      'notifier state should have a week header after the in the last three month section header when no workouts happened this week or in the last month',
      () async {
        final testWorkouts = [
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 35))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 60))),
        ];

        await testRepository.seedWorkoutData(testWorkouts);
        await testNotifier.loadPaginatedWorkouts();

        expect(testNotifier.state.workoutsWithSectionHeaders.length, 5);

        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<WeekWorkoutHistorySectionHeader>()
              .length,
          2,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[0],
          isA<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[1],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[2],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[3],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[4],
          isA<Workout>(),
        );
      },
    );

    test(
      'notifier state should correctly interleave section headers with workouts in a long workout history ',
      () async {
        final testWorkouts = [
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 1))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 2))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 4))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 6))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 1))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 5))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 20))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 42))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 63))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 71))),
        ];

        await testRepository.seedWorkoutData(testWorkouts);
        await testNotifier.loadPaginatedWorkouts();

        expect(testNotifier.state.workoutsWithSectionHeaders.length, 18);

        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<Workout>()
              .length,
          10,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<ThisWeekWorkoutHistorySectionHeader>()
              .length,
          1,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<InTheLastMonthWorkoutHistorySectionHeader>()
              .length,
          1,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<InTheLastThreeMonthsWorkoutHistorySectionHeader>()
              .length,
          1,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<WeekWorkoutHistorySectionHeader>()
              .length,
          5,
        );

        expect(
          testNotifier.state.workoutsWithSectionHeaders[0],
          isA<ThisWeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[1],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[2],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[3],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[4],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[5],
          isA<InTheLastMonthWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[6],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[7],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[8],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[9],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[10],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[11],
          isA<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[12],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[13],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[14],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[15],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[16],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[17],
          isA<Workout>(),
        );
      },
    );

    test(
      'notifier state should correctly interleave week section header when pagination ends mid week',
      () async {
        final testWorkouts = [
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 1))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 2))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 3))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 4))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 5))),
          Workout(date: now.beginningOfTheWeek.add(Duration(days: 6))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 15))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 16))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 17))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 18))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 19))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 20))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 21))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 22))),
          Workout(date: now.beginningOfTheWeek.subtract(Duration(days: 23))),
        ];

        await testRepository.seedWorkoutData(testWorkouts);

        // First Page
        await testNotifier.loadPaginatedWorkouts();
        expect(testNotifier.state.workoutsWithSectionHeaders.length, 13);
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<Workout>()
              .length,
          10,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<ThisWeekWorkoutHistorySectionHeader>()
              .length,
          1,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<InTheLastMonthWorkoutHistorySectionHeader>()
              .length,
          1,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<InTheLastThreeMonthsWorkoutHistorySectionHeader>(),
          isEmpty,
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders
              .whereType<WeekWorkoutHistorySectionHeader>()
              .length,
          1,
        );

        expect(
          testNotifier.state.workoutsWithSectionHeaders[0],
          isA<ThisWeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[1],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[2],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[3],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[4],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[5],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[6],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[7],
          isA<InTheLastMonthWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[8],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[9],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[10],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[11],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[12],
          isA<Workout>(),
        );

        // Second Page
        await testNotifier.loadPaginatedWorkouts();
        expect(testNotifier.state.workoutsWithSectionHeaders.length, 19);
        expect(
          testNotifier.state.workoutsWithSectionHeaders[13],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[14],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[15],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[16],
          isA<WeekWorkoutHistorySectionHeader>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[17],
          isA<Workout>(),
        );
        expect(
          testNotifier.state.workoutsWithSectionHeaders[18],
          isA<Workout>(),
        );
      },
    );
  });
}
