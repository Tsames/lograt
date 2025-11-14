import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/entities/workout.dart';
import '../view_model/workout_log_notifier.dart';

class ExerciseTypeTextButton extends ConsumerWidget {
  final Workout workout;
  final String exerciseId;

  const ExerciseTypeTextButton(this.workout, this.exerciseId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseType = ref.watch(
      workoutLogProvider(workout).select(
        (state) => state.workout.exercises
            .firstWhere((e) => e.id == exerciseId)
            .exerciseType,
      ),
    );

    // final workoutLogNotifier = ref.read(workoutLogProvider(workout).notifier);
    // final theme = Theme.of(context);

    return TextButton(
      onPressed: () {},
      child: Text(switch (exerciseType) {
        null => "Select an Exercise",
        _ => exerciseType.name,
      }),
    );
  }
}
