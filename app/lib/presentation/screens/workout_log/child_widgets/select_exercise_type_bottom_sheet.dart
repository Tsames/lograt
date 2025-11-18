import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/widgets/select_exercise_type_bottom_sheet/exercise_types_notifier.dart';

import '../../../../data/entities/exercise_type.dart';
import '../../../../data/entities/workout.dart';

class SelectExerciseTypeBottomSheet extends ConsumerWidget {
  final Workout workout;
  final ExerciseType? selectedType;

  const SelectExerciseTypeBottomSheet(
    this.workout,
    this.selectedType, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final exerciseTypesState = ref.watch(exerciseTypesProvider);
    final exerciseTypes = exerciseTypesState.exerciseTypes;

    // final workoutLogNotifier = ref.read(workoutLogProvider(workout).notifier);

    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select an Exercise"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: exerciseTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Todo: On tap, change state to selected exercise type and close bottom sheet
                    },
                    child: ListTile(
                      title: Text(
                        exerciseTypes[index].name,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
