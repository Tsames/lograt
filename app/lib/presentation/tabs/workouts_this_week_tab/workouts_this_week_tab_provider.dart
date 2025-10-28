import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/domain/usecases/clear_workouts.dart';

import '../../../di/providers.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/usecases/get_this_weeks_workouts.dart';

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
  final GetThisWeeksWorkouts _getThisWeeksWorkouts;
  final ClearWorkout _clearWorkouts;

  WorkoutsThisWeekTabNotifier(this._getThisWeeksWorkouts, this._clearWorkouts)
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
    await _clearWorkouts();
    state = state.copyWith(workouts: const []);
  }
}

final workoutsThisWeekTabProvider =
    StateNotifierProvider<
      WorkoutsThisWeekTabNotifier,
      WorkoutsThisWeekTabState
    >((ref) {
      final getThisWeeksWorkouts = ref.read(getThisWeeksWorkoutsProvider);
      final clearWorkoutList = ref.read(clearWorkoutProvider);

      return WorkoutsThisWeekTabNotifier(
        getThisWeeksWorkouts,
        clearWorkoutList,
      );
    });
