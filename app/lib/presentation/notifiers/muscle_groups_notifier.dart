import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/muscle_groups/get_paginated_sorted_muscle_groups_usecase.dart';
import 'package:lograt/presentation/notifiers/muscle_groups_notifier_state.dart';

class MuscleGroupsNotifier extends StateNotifier<MuscleGroupNotifierState> {
  final GetPaginatedSortedMuscleGroupsUsecase _getMuscleGroupsUsecase;

  MuscleGroupsNotifier(this._getMuscleGroupsUsecase)
    : super(MuscleGroupNotifierState()) {
    loadMuscleGroups();
  }

  Future<void> loadMuscleGroups() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final paginatedResults = await _getMuscleGroupsUsecase(state.offset);
      state = state.copyWith(
        isLoading: false,
        muscleGroups: state.muscleGroups + paginatedResults.results,
        offset: paginatedResults.nextOffset,
        hasMore: paginatedResults.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final muscleGroupsProvider =
    StateNotifierProvider<MuscleGroupsNotifier, MuscleGroupNotifierState>((
      ref,
    ) {
      final getPaginatedSortedMuscleGroupsUsecase = ref.read(
        getPaginatedSortedMuscleGroupsProvider,
      );
      return MuscleGroupsNotifier(getPaginatedSortedMuscleGroupsUsecase);
    });
