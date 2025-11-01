import '../../../../data/entities/exercise.dart';
import '../../../../data/entities/exercise_type.dart';
import '../../../../data/entities/workout.dart';

class WorkoutLogNotifierState {
  final Workout workout;
  final List<Exercise> exercises;
  final List<ExerciseType> exerciseTypes;
  final bool isLoading;
  final String? error;

  const WorkoutLogNotifierState({
    required this.workout,
    this.exercises = const [],
    this.exerciseTypes = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutLogNotifierState copyWith({
    Workout? workout,
    List<Exercise>? exercises,
    List<ExerciseType>? exerciseTypes,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutLogNotifierState(
      workout: workout ?? this.workout,
      exercises: exercises ?? this.exercises,
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
