import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/entities/workout.dart';
import '../../../data/providers.dart';
import '../../../data/usecases/get_this_weeks_workouts_usecase.dart';

class WorkoutsThisWeekTabState {
  final List<Workout> workoutsThisWeek;
  final bool isLoading;
  final String? error;

  const WorkoutsThisWeekTabState({
    this.workoutsThisWeek = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutsThisWeekTabState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutsThisWeekTabState(
      workoutsThisWeek: workouts ?? workoutsThisWeek,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WorkoutsThisWeekTabNotifier
    extends StateNotifier<WorkoutsThisWeekTabState> {
  final GetThisWeeksWorkoutsUsecase _getThisWeeksWorkouts;

  WorkoutsThisWeekTabNotifier(this._getThisWeeksWorkouts)
    : super(const WorkoutsThisWeekTabState()) {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final workouts = await _getThisWeeksWorkouts();
      state = state.copyWith(workouts: workouts, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> clearWorkouts() async {
    state = state.copyWith(workouts: const []);
  }
}

final workoutsThisWeekTabProvider =
    StateNotifierProvider<
      WorkoutsThisWeekTabNotifier,
      WorkoutsThisWeekTabState
    >((ref) {
      final getThisWeeksWorkouts = ref.read(
        getThisWeeksWorkoutsUsecaseProvider,
      );

      return WorkoutsThisWeekTabNotifier(getThisWeeksWorkouts);
    });
