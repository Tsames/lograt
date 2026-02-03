import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/exercise_types/get_paginated_sorted_exercise_types_usecase.dart';
import 'package:lograt/presentation/notifiers/exercise_types_notifier_state.dart';

class ExerciseTypesNotifier extends StateNotifier<ExerciseTypesNotifierState> {
  final GetPaginatedSortedExerciseTypesUsecase _getExerciseTypesUsecase;

  ExerciseTypesNotifier(this._getExerciseTypesUsecase)
    : super(ExerciseTypesNotifierState()) {
    loadExerciseTypes();
  }

  Future<void> loadExerciseTypes() async {
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final paginatedResults = await _getExerciseTypesUsecase(state.offset);
      state = state.copyWith(
        isLoading: false,
        exerciseTypes: state.exerciseTypes + paginatedResults.results,
        offset: paginatedResults.nextOffset,
        hasMore: paginatedResults.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final exerciseTypesProvider =
    StateNotifierProvider<ExerciseTypesNotifier, ExerciseTypesNotifierState>((
      ref,
    ) {
      final getExerciseTypesUsecase = ref.read(
        getPaginatedSortedExerciseTypesUsecaseProvider,
      );
      return ExerciseTypesNotifier(getExerciseTypesUsecase);
    });
