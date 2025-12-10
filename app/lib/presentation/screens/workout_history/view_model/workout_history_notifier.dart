import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier_state.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';
import 'package:lograt/util/workout_history_section_header.dart';

class WorkoutHistoryNotifier
    extends StateNotifier<WorkoutHistoryNotifierState> {
  final GetPaginatedWorkoutsSortedByCreationDateUsecase
  _getPaginatedSortedWorkouts;
  late final now = DateTime.now();
  late DateTime beginningOfTheIterationWeek =
      state.workoutsWithMarkers.first.date.beginningOfTheWeek;
  late List<Workout> iterationWeek = [];

  WorkoutHistoryNotifier(this._getPaginatedSortedWorkouts)
    : super(const WorkoutHistoryNotifierState()) {
    loadPaginatedWorkouts();
  }

  Future<void> loadPaginatedWorkouts() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paginatedResults = await _getPaginatedSortedWorkouts(state.offset);
      _addWorkoutsToWorkoutHistoryWithMarkers(
        paginatedResults.results,
        paginatedResults.nextOffset,
        paginatedResults.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  void _addWorkoutsToWorkoutHistoryWithMarkers(
    List<Workout> workouts,
    int offset,
    bool hasMore,
  ) {
    bool hasWorkoutsThisWeekMarker = state.hasWorkoutsThisWeekMarker;
    bool hasWorkoutsInLastMonthMarker = state.hasWorkoutsInLastMonthMarker;
    bool hasWorkoutsInLastThreeMonthsMarker =
        state.hasWorkoutsInLastThreeMonthsMarker;

    final List addToWorkoutHistory = [];

    DateTime beginningOfTheIterationWeek =
        state.beginningOfIterationWeek ??
        workouts.first.date.beginningOfTheWeek;
    List iterationWeek = [];

    // If the workoutHistory list doesn't already have the 'This Week' section header
    // and we find a workout that goes in that section, add the header.
    if (!hasWorkoutsThisWeekMarker &&
        ThisWeekWorkoutHistorySectionHeader.inRange(workouts.first, now)) {
      addToWorkoutHistory.add(ThisWeekWorkoutHistorySectionHeader());
      hasWorkoutsThisWeekMarker = true;
    }

    for (final workout in workouts) {
      // Workouts are expected to be ordered in descending order

      // Always check if its applicable to add section headers to the iteration week
      // 'In the Last Month'
      if (!hasWorkoutsInLastMonthMarker &&
          InTheLastMonthWorkoutHistorySectionHeader.inRange(workout, now)) {
        iterationWeek.add(InTheLastMonthWorkoutHistorySectionHeader());
        hasWorkoutsInLastMonthMarker = true;
      }

      // 'In the Last Three Months'
      if (!hasWorkoutsInLastThreeMonthsMarker &&
          InTheLastThreeMonthsWorkoutHistorySectionHeader.inRange(
            workout,
            now,
          )) {
        iterationWeek.add(InTheLastThreeMonthsWorkoutHistorySectionHeader());
        hasWorkoutsInLastThreeMonthsMarker = true;
      }

      if (workout.date.isBefore(beginningOfTheIterationWeek)) {
        /*
          Once we hit a workout with a date that is BEFORE the beginning of the week we are iterating on:
            1. Add all workouts of the iterating week to workout history
            2. Set new beginningOfTheIterationWeek and reset iterationWeek
            3. Add a marker for the following week to the iterationWeek
         */
        addToWorkoutHistory.addAll(iterationWeek);

        beginningOfTheIterationWeek = workout.date.beginningOfTheWeek;
        iterationWeek = [];

        iterationWeek.add(WeekWorkoutHistorySectionHeader(workout.date));
        iterationWeek.add(workout);
      } else {
        iterationWeek.add(workout);
      }
    }

    state = state.copyWith(
      workoutsWithMarkers: state.workoutsWithMarkers + addToWorkoutHistory,
      hasWorkoutsThisWeekMarker: hasWorkoutsThisWeekMarker,
      hasWorkoutsInLastMonthMarker: hasWorkoutsInLastMonthMarker,
      hasWorkoutsInLastThreeMonthsMarker: hasWorkoutsInLastThreeMonthsMarker,
      beginningOfIterationWeek: beginningOfTheIterationWeek,
      isLoading: false,
      offset: offset,
      hasMore: hasMore,
    );
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
