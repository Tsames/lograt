import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/get_most_recent_workouts.dart';

// This represents the state of your workout list screen
class WorkoutListState {
  final List<Workout> workouts;
  final bool isLoading;
  final String? error;

  const WorkoutListState({this.workouts = const [], this.isLoading = false, this.error});

  WorkoutListState copyWith({List<Workout>? workouts, bool? isLoading, String? error}) {
    return WorkoutListState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// This is your ViewModel using StateNotifier
// It handles all business logic coordination for the workout list screen
class WorkoutListNotifier extends StateNotifier<WorkoutListState> {
  final GetMostRecentWorkouts _getMostRecentWorkouts;

  WorkoutListNotifier(this._getMostRecentWorkouts) : super(const WorkoutListState()) {
    loadWorkouts();
  }

  // This method handles loading workouts with proper error handling
  Future<void> loadWorkouts() async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Use the use case to get workouts - this is where business logic happens
      final workouts = await _getMostRecentWorkouts();

      // Update state with successful data
      state = state.copyWith(workouts: workouts, isLoading: false);
    } catch (error) {
      // Handle errors gracefully
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

// Provider for your ViewModel
// This is what your UI will watch for state changes
final workoutListProvider = StateNotifierProvider<WorkoutListNotifier, WorkoutListState>((ref) {
  final getMostRecentWorkouts = ref.read(getMostRecentWorkoutsProvider);

  return WorkoutListNotifier(getMostRecentWorkouts);
});
