import '../../../../data/entities/workout.dart';

class WorkoutLogNotifierState {
  final Workout workout;
  final bool isLoading;
  final String? error;

  const WorkoutLogNotifierState({
    required this.workout,
    this.isLoading = false,
    this.error,
  });

  WorkoutLogNotifierState copyWith({
    Workout? workout,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutLogNotifierState(
      workout: workout ?? this.workout,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
