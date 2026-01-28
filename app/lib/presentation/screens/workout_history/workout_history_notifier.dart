import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/workouts/delete_workout_usecase.dart';
import 'package:lograt/data/usecases/workouts/get_paginated_sorted_workouts_usecase.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_notifier_state.dart';

class WorkoutHistoryNotifier
    extends StateNotifier<WorkoutHistoryNotifierState> {
  final GetPaginatedSortedWorkoutsUsecase _getPaginatedSortedWorkouts;
  final DeleteWorkoutUsecase _deleteWorkoutUsecase;
  late final now = DateTime.now();

  WorkoutHistoryNotifier(
    this._getPaginatedSortedWorkouts,
    this._deleteWorkoutUsecase,
  ) : super(const WorkoutHistoryNotifierState());

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
          hasMore: false,
          offset: paginatedResults.nextOffset,
        );
        return;
      }

      state = state.copyWith(
        workouts: state.workouts + paginatedResults.results,
        isLoading: false,
        hasMore: paginatedResults.hasMore,
        offset: paginatedResults.nextOffset,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  void deleteWorkout(String workoutId) async {
    try {
      await _deleteWorkoutUsecase.call(workoutId);

      state = state.copyWith(
        workouts: state.workouts.where((w) => w.id != workoutId).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final workoutHistoryProvider =
    StateNotifierProvider<WorkoutHistoryNotifier, WorkoutHistoryNotifierState>((
      ref,
    ) {
      final getSortedWorkoutsUsecase = ref.read(
        getPaginatedSortedWorkoutsUsecaseProvider,
      );
      final deleteWorkoutUsecase = ref.read(deleteWorkoutUsecaseProvider);

      return WorkoutHistoryNotifier(
        getSortedWorkoutsUsecase,
        deleteWorkoutUsecase,
      );
    });
