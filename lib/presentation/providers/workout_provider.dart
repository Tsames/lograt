import '../../domain/entities/workout.dart';

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
