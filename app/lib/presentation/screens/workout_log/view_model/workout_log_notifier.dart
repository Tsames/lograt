import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier_state.dart';

import '../../../../data/entities/workout.dart';
import '../../../../data/usecases/get_all_exercise_types_usecase.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogNotifierState> {
  final GetExerciseTypesUsecase _getExerciseTypesUsecase;

  WorkoutLogNotifier(this._getExerciseTypesUsecase, Workout workout)
    : super(WorkoutLogNotifierState(workout: workout)) {
    loadExerciseTypes();
  }

  WorkoutLogNotifier.empty(GetExerciseTypesUsecase getExerciseTypesUsecase)
    : this(getExerciseTypesUsecase, Workout.empty());

  Future<void> loadExerciseTypes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final exerciseTypes = await _getExerciseTypesUsecase();
      state = state.copyWith(isLoading: false, exerciseTypes: exerciseTypes);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final workoutLogProvider =
    StateNotifierProvider<WorkoutLogNotifier, WorkoutLogNotifierState>((ref) {
      final getExerciseTypesUsecase = ref.read(getExerciseTypesUsecaseProvider);
      return WorkoutLogNotifier.empty(getExerciseTypesUsecase);
    });
