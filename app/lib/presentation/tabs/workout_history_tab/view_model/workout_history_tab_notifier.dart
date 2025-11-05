import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/view_model/workout_history_tab_notifier_state.dart';

import '../../../../data/providers.dart';
import '../../../../data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';

class WorkoutHistoryTabNotifier
    extends StateNotifier<WorkoutHistoryTabNotifierState> {
  final GetPaginatedWorkoutsSortedByCreationDateUsecase
  _getPaginatedSortedWorkouts;

  WorkoutHistoryTabNotifier(this._getPaginatedSortedWorkouts)
    : super(const WorkoutHistoryTabNotifierState()) {
    loadPaginatedWorkouts();
  }

  Future<void> loadPaginatedWorkouts() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paginatedResults = await _getPaginatedSortedWorkouts(state.offset);
      state = state.copyWith(
        workouts: state.sortedWorkouts + paginatedResults.results,
        isLoading: false,
        offset: paginatedResults.nextOffset,
        hasMore: paginatedResults.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final workoutHistoryTabProvider =
    StateNotifierProvider<
      WorkoutHistoryTabNotifier,
      WorkoutHistoryTabNotifierState
    >((ref) {
      final getSortedWorkouts = ref.read(
        getSortedPaginatedWorkoutsUsecaseProvider,
      );

      return WorkoutHistoryTabNotifier(getSortedWorkouts);
    });
