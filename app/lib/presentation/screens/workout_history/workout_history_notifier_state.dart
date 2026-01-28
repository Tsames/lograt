import 'package:lograt/data/entities/workouts/workout.dart';

class WorkoutHistoryNotifierState {
  final List<Workout> workouts;

  final bool isLoading;
  final String? error;

  final int offset;
  final bool hasMore;

  const WorkoutHistoryNotifierState({
    this.workouts = const [],
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  WorkoutHistoryNotifierState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return WorkoutHistoryNotifierState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
