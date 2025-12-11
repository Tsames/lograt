import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/get_paginated_sorted_workouts_usecase.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier_state.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';
import 'package:lograt/util/workout_history_section_header.dart';

class WorkoutHistoryNotifier
    extends StateNotifier<WorkoutHistoryNotifierState> {
  final GetPaginatedSortedWorkoutsUsecase _getPaginatedSortedWorkouts;
  late final now = DateTime.now();

  WorkoutHistoryNotifier(this._getPaginatedSortedWorkouts)
    : super(const WorkoutHistoryNotifierState());

  Future<void> loadPaginatedWorkouts() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paginatedResults = await _getPaginatedSortedWorkouts(state.offset);
      final paginatedWorkouts = paginatedResults.results;

      // If we fail to fetch any new workouts, early return

      if (paginatedWorkouts.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: paginatedResults.hasMore,
          offset: paginatedResults.nextOffset,
        );
      }

      /*
        If the paginated results we fetch are not empty then we iterate over the new workouts
        We add section headers and workouts in groups of weeks
        We rely on workouts being ordered in descending order
        Workouts older than three months old should not be added to state.
      */

      bool hasWorkoutsThisWeekSectionHeader =
          state.hasWorkoutsThisWeekSectionHeader;
      bool hasWorkoutsInLastMonthSectionHeader =
          state.hasWorkoutsInLastMonthSectionHeader;
      bool hasWorkoutsInLastThreeMonthsSectionHeader =
          state.hasWorkoutsInLastThreeMonthsSectionHeader;
      bool hasMore = paginatedResults.hasMore;
      final List addToWorkoutHistory = [];

      DateTime beginningOfTheIterationWeek =
          state.beginningOfIterationWeek ??
          paginatedWorkouts.first.date.beginningOfTheWeek;
      List iterationWeek = [];

      for (final workout in paginatedWorkouts) {
        // If we find a workout older than three months, we set hasMore to false so we don't make repeated unnecessary calls of this method
        if (workout.date.isBefore(now.beginningOfTheLastThreeMonths)) {
          hasMore = false;
          break;
        }

        // On each iteration we need to check if its applicable to add section headers to the iteration week
        if (!hasWorkoutsThisWeekSectionHeader &&
            ThisWeekWorkoutHistorySectionHeader.inRange(workout, now)) {
          iterationWeek.add(ThisWeekWorkoutHistorySectionHeader());
          hasWorkoutsThisWeekSectionHeader = true;

          // Don't add a weekly header because 'This Week' is a glorified weekly header
        }

        if (!hasWorkoutsInLastMonthSectionHeader &&
            InTheLastMonthWorkoutHistorySectionHeader.inRange(workout, now)) {
          iterationWeek.add(InTheLastMonthWorkoutHistorySectionHeader());
          hasWorkoutsInLastMonthSectionHeader = true;

          // If 'In the last month' is the first section header, add a weekly header right after it
          if (state.workoutsWithSectionHeaders.isEmpty &&
              iterationWeek.length == 1) {
            iterationWeek.add(WeekWorkoutHistorySectionHeader(workout.date));
          }
        }

        if (!hasWorkoutsInLastThreeMonthsSectionHeader &&
            InTheLastThreeMonthsWorkoutHistorySectionHeader.inRange(
              workout,
              now,
            )) {
          iterationWeek.add(InTheLastThreeMonthsWorkoutHistorySectionHeader());
          hasWorkoutsInLastThreeMonthsSectionHeader = true;

          // If 'In the last three months' is the first section header, add a weekly header right after it
          if (state.workoutsWithSectionHeaders.isEmpty &&
              iterationWeek.length == 1) {
            iterationWeek.add(WeekWorkoutHistorySectionHeader(workout.date));
          }
        }

        /*
        Once we hit a workout with a date that is BEFORE the beginning of the week we are iterating on:
          1. Add all members of iterationWeek to the addToWorkoutHistory list
          2. Set new beginningOfTheIterationWeek and reset iterationWeek
          3. Add a week section header to the new iterationWeek
          4. Add the current workout to the new iterationWeek
      */
        if (workout.date.isBefore(beginningOfTheIterationWeek)) {
          addToWorkoutHistory.addAll(iterationWeek);

          beginningOfTheIterationWeek = workout.date.beginningOfTheWeek;
          iterationWeek = [];

          iterationWeek.add(WeekWorkoutHistorySectionHeader(workout.date));
          iterationWeek.add(workout);

          // Otherwise, just add the workout to the iteration week
        } else {
          iterationWeek.add(workout);
        }
      }

      // Add any workouts and section headers of the final iteration week to addToWorkoutHistory list
      addToWorkoutHistory.addAll(iterationWeek);

      state = state.copyWith(
        workoutsWithSectionHeaders:
            state.workoutsWithSectionHeaders + addToWorkoutHistory,
        hasWorkoutsThisWeekMarker: hasWorkoutsThisWeekSectionHeader,
        hasWorkoutsInLastMonthMarker: hasWorkoutsInLastMonthSectionHeader,
        hasWorkoutsInLastThreeMonthsMarker:
            hasWorkoutsInLastThreeMonthsSectionHeader,
        beginningOfIterationWeek: beginningOfTheIterationWeek,
        isLoading: false,
        hasMore: hasMore,
        offset: paginatedResults.nextOffset,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final workoutHistoryProvider =
    StateNotifierProvider<WorkoutHistoryNotifier, WorkoutHistoryNotifierState>((
      ref,
    ) {
      final getSortedWorkouts = ref.read(
        getSortedPaginatedWorkoutsUsecaseProvider,
      );

      return WorkoutHistoryNotifier(getSortedWorkouts);
    });
