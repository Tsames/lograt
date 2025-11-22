import 'package:lograt/data/entities/workout.dart';

class WorkoutHistoryTabNotifierState {
  final List<Workout> sortedWorkouts;
  final bool isLoading;
  final String? error;
  final int offset;
  final bool hasMore;

  const WorkoutHistoryTabNotifierState({
    this.sortedWorkouts = const [],
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  WorkoutHistoryTabNotifierState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return WorkoutHistoryTabNotifierState(
      sortedWorkouts: workouts ?? sortedWorkouts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
