import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/domain/usecases/clear_workouts.dart';

import '../../di/providers.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/get_most_recent_workouts.dart';

// This represents the state of the workout history widget
class WorkoutHistoryState {
  final List<Workout> workouts;
  final bool isLoading;
  final String? error;

  const WorkoutHistoryState({
    this.workouts = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutHistoryState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutHistoryState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// This is the ViewModel using StateNotifier
class WorkoutHistoryNotifier extends StateNotifier<WorkoutHistoryState> {
  final GetMostRecentWorkouts _getMostRecentWorkouts;
  final ClearWorkout _clearWorkouts;

  WorkoutHistoryNotifier(this._getMostRecentWorkouts, this._clearWorkouts)
    : super(const WorkoutHistoryState()) {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final workouts = await _getMostRecentWorkouts();
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

// Provider for the ViewModel
// This is what the UI will watch for state changes
final workoutHistoryProvider =
    StateNotifierProvider<WorkoutHistoryNotifier, WorkoutHistoryState>((ref) {
      final getMostRecentWorkouts = ref.read(getMostRecentWorkoutsProvider);
      final clearWorkoutList = ref.read(clearWorkoutProvider);

      return WorkoutHistoryNotifier(getMostRecentWorkouts, clearWorkoutList);
    });
