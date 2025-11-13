import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/exercise.dart';
import 'package:lograt/data/usecases/get_full_workout_data_by_id_usecase.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier_state.dart';

import '../../../../data/entities/exercise_set.dart';
import '../../../../data/entities/set_type.dart';
import '../../../../data/entities/units.dart';
import '../../../../data/entities/workout.dart';
import '../../../../data/providers.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogNotifierState> {
  final GetFullWorkoutDataByIdUsecase _getFullWorkoutDataByIdUsecase;

  WorkoutLogNotifier(this._getFullWorkoutDataByIdUsecase, Workout workout)
    : super(WorkoutLogNotifierState(workout: workout)) {
    loadFullWorkoutData();
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

  void addSetToExercise(Exercise exercise) {
    final targetExerciseIndex = state.workout.exercises.indexOf(exercise);
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

    // Create a copy of the list of exercises for this workout but with the new set added to the target exercise
    final newExercises = [...state.workout.exercises]
      ..[targetExerciseIndex] = targetExercise.copyWith(
        sets: [...targetExercise.sets, newSet],
      );

    state = state.copyWith(
      workout: state.workout.copyWith(exercises: newExercises),
    );

    try {
      // todo: save to database
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void duplicateLastSetOfExercise(Exercise exercise) {
    final targetExerciseIndex = state.workout.exercises.indexOf(exercise);
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

    // Create a copy of the list of exercises for this workout but with the new set added to the target exercise
    final newExercises = [...state.workout.exercises]
      ..[targetExerciseIndex] = targetExercise.copyWith(
        sets: [...targetExercise.sets, newSet],
      );

    state = state.copyWith(
      workout: state.workout.copyWith(exercises: newExercises),
    );
    try {
      // todo: save to database
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void removeLastSetFromExercise(Exercise exercise) {
    final targetExerciseIndex = state.workout.exercises.indexOf(exercise);
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: "Cannot remove a set of an exercise outside of this workout.",
      );
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];
    final lastSetOfTargetExercise = targetExercise.sets.lastOrNull;

    // Do nothing if there are no sets
    if (lastSetOfTargetExercise == null) return;

    // Create a copy of the list of exercises for this workout but without the last set of the target exercise
    final newExercises = [...state.workout.exercises]
      ..[targetExerciseIndex] = targetExercise.copyWith(
        sets: [...targetExercise.sets]..removeLast(),
      );

    state = state.copyWith(
      workout: state.workout.copyWith(exercises: newExercises),
    );
    try {
      // todo: save to database
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
      return WorkoutLogNotifier(getFullWorkoutDataByIdUsecase, workout);
    });
