import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/usecases/get_full_workout_data_by_id_usecase.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier_state.dart';

import '../../../../data/entities/workout.dart';
import '../../../../data/providers.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogNotifierState> {
  final GetFullWorkoutDataByIdUsecase _getFullWorkoutDataByIdUsecase;

  WorkoutLogNotifier(this._getFullWorkoutDataByIdUsecase, Workout workout)
    : super(WorkoutLogNotifierState(workout: workout)) {
    loadFullWorkoutData();
  }

  Future<void> loadFullWorkoutData() async {
    if (state.workout.id == null) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fullWorkoutData = await _getFullWorkoutDataByIdUsecase(
        state.workout.id!,
      );
      state = state.copyWith(isLoading: false, workout: fullWorkoutData);
    } catch (stacktrace, error) {
      state = state.copyWith(isLoading: false, error: error.toString());
      rethrow;
    }
  }
}

final workoutLogProvider = StateNotifierProvider.autoDispose
    .family<WorkoutLogNotifier, WorkoutLogNotifierState, Workout>((
      ref,
      Workout workout,
    ) {
      final getFullWorkoutDataByIdUsecase = ref.read(
        getFullWorkoutDataByIdUsecaseProvider,
      );
      return WorkoutLogNotifier(getFullWorkoutDataByIdUsecase, workout);
    });
