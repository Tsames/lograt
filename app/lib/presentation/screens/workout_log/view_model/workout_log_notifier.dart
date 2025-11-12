import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/usecases/get_full_workout_data_by_id_usecase.dart';
import 'package:lograt/data/usecases/update_or_create_workout_usecase.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier_state.dart';

import '../../../../data/entities/exercise_set.dart';
import '../../../../data/entities/set_type.dart';
import '../../../../data/entities/units.dart';
import '../../../../data/entities/workout.dart';
import '../../../../data/providers.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogNotifierState> {
  final GetFullWorkoutDataByIdUsecase _getFullWorkoutDataByIdUsecase;
  final UpdateOrCreateWorkoutDataUsecase _updateOrCreateWorkoutUsecase;

  WorkoutLogNotifier(
    this._getFullWorkoutDataByIdUsecase,
    this._updateOrCreateWorkoutUsecase,
    Workout? workout,
  ) : super(WorkoutLogNotifierState(workout: workout ?? Workout())) {
    if (workout != null) {
      loadFullWorkoutData();
    } else {
      _updateOrCreateWorkoutUsecase.createWorkout(state.workout);
    }
  }

  Future<void> loadFullWorkoutData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fullWorkoutData = await _getFullWorkoutDataByIdUsecase(
        state.workout.id,
      );
      state = state.copyWith(isLoading: false, workout: fullWorkoutData);
    } catch (stacktrace, error) {
      state = state.copyWith(isLoading: false, error: error.toString());
      rethrow;
    }
  }

  void updateSet(ExerciseSet set, String exerciseId) async {
    try {
      await _updateOrCreateWorkoutUsecase.updateSet(set, exerciseId);
    } catch (e) {
      state = state.copyWith(error: "An error occurred while editing a set.");
    }
  }

  void addSetToExercise(String exerciseId) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: "Cannot add a set to an exercise outside of this workout.",
      );
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];
    final lastSetOfTargetExercise = targetExercise.sets.lastOrNull;

    // Todo: Eventually it should default to a user preference setting rather than be hard coded
    // If the new set is first in the list of sets, make default to a warm up and pounds
    // Otherwise, copy the set type and units of the previous set
    final newSet = switch (lastSetOfTargetExercise) {
      null => ExerciseSet(setType: SetType.warmup, units: Units.pounds),
      _ => ExerciseSet(
        order: lastSetOfTargetExercise.order + 1,
        setType: lastSetOfTargetExercise.setType,
        units: lastSetOfTargetExercise.units,
      ),
    };

    // Copy the existing exercise, but with a new list for the sets (triggering a rebuild of the record_exercise widget)
    final copyOfTargetExercise = targetExercise.copyWith(
      sets: [...targetExercise.sets, newSet],
    );

    /*
      Optimistic update
      Copy the existing exercises list (avoiding triggering a rebuild of the workout_log widget)
      Replace the target exercise with the copy that was just created above
    */
    state = state.copyWith(
      workout: state.workout.copyWith(
        exercises: state.workout.exercises
          ..[targetExerciseIndex] = copyOfTargetExercise,
      ),
    );

    try {
      _updateOrCreateWorkoutUsecase.createSet(newSet, exerciseId);
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void duplicateLastSetOfExercise(String exerciseId) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: "Cannot duplicate a set of an exercise outside of this workout.",
      );
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];
    final lastSetOfTargetExercise = targetExercise.sets.lastOrNull;

    // Do nothing if there are no sets
    if (lastSetOfTargetExercise == null) return;

    final newSet = ExerciseSet(
      order: lastSetOfTargetExercise.order + 1,
      setType: lastSetOfTargetExercise.setType,
      weight: lastSetOfTargetExercise.weight,
      units: lastSetOfTargetExercise.units,
      reps: lastSetOfTargetExercise.reps,
      restTime: lastSetOfTargetExercise.restTime,
    );

    // Copy the existing exercise, but with a new list for the sets (triggering a rebuild of the record_exercise widget)
    final copyOfTargetExercise = targetExercise.copyWith(
      sets: [...targetExercise.sets, newSet],
    );

    /*
      Optimistic update
      Copy the existing exercises list (avoiding triggering a rebuild of the workout_log widget)
      Replace the target exercise with the copy that was just created above
    */
    state = state.copyWith(
      workout: state.workout.copyWith(
        exercises: state.workout.exercises
          ..[targetExerciseIndex] = copyOfTargetExercise,
      ),
    );
    try {
      _updateOrCreateWorkoutUsecase.createSet(newSet, exerciseId);
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void removeLastSetFromExercise(String exerciseId) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: "Cannot remove a set of an exercise outside of this workout.",
      );
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];
    final lastSetOfTargetExercise = targetExercise.sets.lastOrNull;

    // Do nothing if there are no sets
    if (lastSetOfTargetExercise == null) return;

    // Copy the existing exercise, but with a new list for the sets (triggering a rebuild of the record_exercise widget)
    final copyOfTargetExercise = targetExercise.copyWith(
      sets: [...targetExercise.sets]..removeLast(),
    );

    /*
      Optimistic update
      Copy the existing exercises list (avoiding triggering a rebuild of the workout_log widget)
      Replace the target exercise with the copy that was just created above
    */
    state = state.copyWith(
      workout: state.workout.copyWith(
        exercises: state.workout.exercises
          ..[targetExerciseIndex] = copyOfTargetExercise,
      ),
    );
    try {
      _updateOrCreateWorkoutUsecase.removeSet(
        lastSetOfTargetExercise,
        exerciseId,
      );
    } catch (error) {
      // todo: handle exceptions
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
      final updateOrCreateWorkoutUsecase = ref.read(
        updateOrCreateWorkoutUsecaseProvider,
      );
      return WorkoutLogNotifier(
        getFullWorkoutDataByIdUsecase,
        updateOrCreateWorkoutUsecase,
        workout,
      );
    });
