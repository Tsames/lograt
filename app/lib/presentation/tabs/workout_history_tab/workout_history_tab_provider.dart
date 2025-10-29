import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/entities/workout.dart';
import '../../../data/providers.dart';
import '../../../data/usecases/get_paginated_workouts_sorted_by_creation_date_usecase.dart';

class WorkoutHistoryTabState {
  final List<Workout> sortedWorkouts;
  final bool isLoading;
  final String? error;
  final int offset;
  final bool hasMore;

  const WorkoutHistoryTabState({
    this.sortedWorkouts = const [],
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  WorkoutHistoryTabState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return WorkoutHistoryTabState(
      sortedWorkouts: workouts ?? sortedWorkouts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class WorkoutHistoryTabNotifier extends StateNotifier<WorkoutHistoryTabState> {
  final GetPaginatedWorkoutsSortedByCreationDateUsecase
  _getPaginatedSortedWorkouts;

  WorkoutHistoryTabNotifier(this._getPaginatedSortedWorkouts)
    : super(const WorkoutHistoryTabState()) {
    loadPaginatedWorkouts();
  }

  Future<void> loadPaginatedWorkouts() async {
    if (!state.hasMore) return;
    if (kDebugMode) {
      debugPrint(
        'Loading new page of workouts from database with offset: ${state.offset}',
      );
    }
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paginatedResults = await _getPaginatedSortedWorkouts(state.offset);
      state = state.copyWith(
        workouts: state.sortedWorkouts + paginatedResults.workouts,
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
    StateNotifierProvider<WorkoutHistoryTabNotifier, WorkoutHistoryTabState>((
      ref,
    ) {
      final getSortedWorkouts = ref.read(
        getSortedPaginatedWorkoutsUsecaseProvider,
      );

      return WorkoutHistoryTabNotifier(getSortedWorkouts);
    });
