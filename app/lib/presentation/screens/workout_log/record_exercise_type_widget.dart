import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier.dart';

import '../../../data/entities/exercise_type.dart';

class RecordExerciseTypeWidget extends ConsumerWidget {
  const RecordExerciseTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseTypes = ref.watch(
      workoutLogProvider.select((state) => state.exerciseTypes),
    );
    return DropdownMenu<ExerciseType?>(
      hintText: "Select an exercise",
      dropdownMenuEntries: exerciseTypes.map((exerciseType) {
        return DropdownMenuEntry(value: exerciseType, label: exerciseType.name);
      }).toList(),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
      // Todo: update state based on selection
      // onSelected: () {},
    );
  }
}
