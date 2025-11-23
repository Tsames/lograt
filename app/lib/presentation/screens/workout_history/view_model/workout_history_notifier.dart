import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier_state.dart';

class WorkoutHistoryNotifier
    extends StateNotifier<WorkoutHistoryNotifierState> {
  final GetPaginatedWorkoutsSortedByCreationDateUsecase
  _getPaginatedSortedWorkouts;
  late final now = DateTime.now();

  WorkoutHistoryNotifier(this._getPaginatedSortedWorkouts)
    : super(const WorkoutHistoryNotifierState());

  Future<void> loadPaginatedWorkouts() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paginatedResults = await _getPaginatedSortedWorkouts(state.offset);
      state = state.copyWith(
        workouts: state.workouts + paginatedResults.results,
        isLoading: false,
        offset: paginatedResults.nextOffset,
        hasMore: paginatedResults.hasMore,
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
