import 'package:lograt/data/entities/muscle_group.dart';

class MuscleGroupNotifierState {
  final List<MuscleGroup> muscleGroups;
  final bool isLoading;
  final String? error;
  final int offset;
  final bool hasMore;

  const MuscleGroupNotifierState({
    this.muscleGroups = const [],
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  MuscleGroupNotifierState copyWith({
    List<MuscleGroup>? muscleGroups,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return MuscleGroupNotifierState(
      muscleGroups: muscleGroups ?? this.muscleGroups,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
