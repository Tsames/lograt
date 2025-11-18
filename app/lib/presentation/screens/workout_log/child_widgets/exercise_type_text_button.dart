import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/select_exercise_type_bottom_sheet.dart';

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

    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SelectExerciseTypeBottomSheet(workout, exerciseType);
          },
        );
      },
      child: Text(switch (exerciseType) {
        null => "Select an Exercise",
        _ => exerciseType.name,
      }),
    );
  }
}
