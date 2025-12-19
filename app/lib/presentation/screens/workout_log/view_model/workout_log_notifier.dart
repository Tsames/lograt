import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/data/providers.dart';
import 'package:lograt/data/usecases/exercise_sets/create_exercise_set_usecase.dart';
import 'package:lograt/data/usecases/exercise_sets/update_exercise_set_usecase.dart';
import 'package:lograt/data/usecases/exercises/update_exercise_usecase.dart';
import 'package:lograt/data/usecases/workouts/create_workout_usecase.dart';
import 'package:lograt/data/usecases/workouts/get_full_workout_data_by_id_usecase.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier_state.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogNotifierState> {
  final GetFullWorkoutDataByIdUsecase _getFullWorkoutDataByIdUsecase;
  final CreateWorkoutUsecase _createWorkoutUsecase;

  // final DeleteWorkoutUsecase _deleteWorkoutUsecase;

  // final CreateExerciseUsecase _createExerciseUsecase;
  final UpdateExerciseUsecase _updateExerciseUsecase;

  // final DeleteExerciseUsecase _deleteExerciseUsecase;

  final CreateExerciseSetUsecase _createExerciseSetUsecase;
  final UpdateExerciseSetUsecase _updateExerciseSetUsecase;

  // final DeleteExerciseSetUsecase _deleteExerciseSetUsecase;

  WorkoutLogNotifier(
    this._getFullWorkoutDataByIdUsecase,
    this._createWorkoutUsecase,
    // this._deleteWorkoutUsecase,
    // this._createExerciseUsecase,
    this._updateExerciseUsecase,
    // this._deleteExerciseUsecase,
    this._createExerciseSetUsecase,
    this._updateExerciseSetUsecase,
    // this._deleteExerciseSetUsecase,
    Workout? workout,
  ) : super(WorkoutLogNotifierState(workout: workout ?? Workout())) {
    if (workout != null) {
      loadFullWorkoutData();
    } else {
      _createWorkoutUsecase.call(state.workout);
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

  void updateExerciseType(
    ExerciseType? newExerciseType,
    String exerciseId,
  ) async {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error:
            'Cannot change exercise type for a an exercise outside of this workout.',
      );
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];
    final newExercise = targetExercise.copyWith(exerciseType: newExerciseType);

    state = state.copyWith(
      workout: state.workout.copyWith(
        exercises: state.workout.exercises..[targetExerciseIndex] = newExercise,
      ),
    );
    try {
      _updateExerciseUsecase.updateSingleExercise(
        newExercise,
        state.workout.id,
      );
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void updateSet(String exerciseId, ExerciseSet newSet, int setIndex) async {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: 'Cannot update a set for an exercise outside of this workout.',
      );
      return;
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];

    // If the index is out of bounds change state and return early.
    if (targetExercise.sets.isEmpty || targetExercise.sets.length <= setIndex) {
      state = state.copyWith(
        error: 'Target set index [$setIndex] for duplication is out of bounds.',
      );
      return;
    }

    // Copy existing state with existing sets but just change set data (does not trigger a rebuild of exercise_table widget)
    state = state.copyWith(
      workout: state.workout.copyWith(
        exercises: state.workout.exercises
          ..[targetExerciseIndex] = targetExercise.copyWith(
            sets: [...targetExercise.sets]..[setIndex] = newSet,
          ),
      ),
    );

    try {
      await _updateExerciseSetUsecase.updateSingleSet(newSet, exerciseId);
    } catch (e) {
      state = state.copyWith(error: 'An error occurred while editing a set.');
    }
  }

  void addSetToExercise(String exerciseId) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: 'Cannot add a set to an exercise outside of this workout.',
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
      _createExerciseSetUsecase.call(newSet, exerciseId);
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void duplicateSetOfExercise(String exerciseId, int setIndex) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: 'Cannot duplicate a set of an exercise outside of this workout.',
      );
      return;
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];

    // If the index is out of bounds change state and return early.
    if (targetExercise.sets.isEmpty || targetExercise.sets.length <= setIndex) {
      state = state.copyWith(
        error: 'Target set index [$setIndex] for duplication is out of bounds.',
      );
      return;
    }

    final targetSet = targetExercise.sets[setIndex];

    final newSet = ExerciseSet(
      order: targetSet.order + 1,
      setType: targetSet.setType,
      weight: targetSet.weight,
      units: targetSet.units,
      reps: targetSet.reps,
      restTime: targetSet.restTime,
    );

    // Copy the existing exercise, but with a new list for the sets (triggering a rebuild of the exercise_table widget only)
    final copyOfTargetExercise = targetExercise.copyWith(
      sets: [...targetExercise.sets]..insert(setIndex + 1, newSet),
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
      // todo: update database - which includes updating the order property of each set that was displaced
      // _updateOrCreateWorkoutUsecase.createSet(newSet, exerciseId);
    } catch (error) {
      // todo: handle exceptions
      rethrow;
    }
  }

  void removeSetFromExercise(String exerciseId, int setIndex) {
    final targetExerciseIndex = state.workout.exercises.indexWhere(
      (e) => e.id == exerciseId,
    );
    if (targetExerciseIndex == -1) {
      state = state.copyWith(
        error: 'Cannot duplicate a set of an exercise outside of this workout.',
      );
      return;
    }

    final targetExercise = state.workout.exercises[targetExerciseIndex];

    // If the index is out of bounds change state and return early.
    if (targetExercise.sets.isEmpty || targetExercise.sets.length <= setIndex) {
      state = state.copyWith(
        error: 'Target set index [$setIndex] for removal is out of bounds.',
      );
      return;
    }

    // Copy the existing exercise, but with a new list for the sets (triggering a rebuild of the exercise_table widget only)
    final copyOfTargetExercise = targetExercise.copyWith(
      sets: [...targetExercise.sets]..removeAt(setIndex),
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
      //todo: update database
      // _deleteExerciseSetUsecase.call(lastSetOfTargetExercise);
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
      final createWorkoutUsecase = ref.read(createWorkoutUsecaseProvider);
      // final deleteWorkoutUsecase = ref.read(deleteWorkoutUsecaseProvider);

      // final createExerciseUsecase = ref.read(createExerciseUsecaseProvider);
      final updateExerciseUsecase = ref.read(updateExerciseUsecaseProvider);
      // final deleteExerciseUsecase = ref.read(deleteExerciseUsecaseProvider);

      final createExerciseSetUsecase = ref.read(
        createExerciseSetUsecaseProvider,
      );
      final updateExerciseSetUsecase = ref.read(
        updateExerciseSetUsecaseProvider,
      );
      // final deleteExerciseSetUsecase = ref.read(deleteExerciseSetUsecaseProvider);

      return WorkoutLogNotifier(
        getFullWorkoutDataByIdUsecase,
        createWorkoutUsecase,
        // deleteWorkoutUsecase,
        // createExerciseUsecase,
        updateExerciseUsecase,
        // deleteExerciseUsecase,
        createExerciseSetUsecase,
        updateExerciseSetUsecase,
        // deleteExerciseSetUsecase,
        workout,
      );
    });
