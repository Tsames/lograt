import 'package:lograt/data/entities/workouts/exercise_type.dart';

class ExerciseTypesNotifierState {
  final List<ExerciseType> exerciseTypes;
  final bool isLoading;
  final String? error;
  final int offset;
  final bool hasMore;

  const ExerciseTypesNotifierState({
    this.exerciseTypes = const [],
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  ExerciseTypesNotifierState copyWith({
    List<ExerciseType>? exerciseTypes,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return ExerciseTypesNotifierState(
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
