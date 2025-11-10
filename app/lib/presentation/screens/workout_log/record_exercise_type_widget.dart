import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/exercise_types_notifier.dart';

import '../../../data/entities/exercise_type.dart';

class RecordExerciseTypeWidget extends ConsumerWidget {
  final ExerciseType? selectedType;

  const RecordExerciseTypeWidget(this.selectedType, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseTypesState = ref.watch(exerciseTypesProvider);
    return DropdownMenu<ExerciseType?>(
      hintText: "Select an exercise",
      initialSelection: selectedType,
      dropdownMenuEntries: exerciseTypesState.exerciseTypes.map((exerciseType) {
        return DropdownMenuEntry(value: exerciseType, label: exerciseType.name);
      }).toList(),
      inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
      menuStyle: const MenuStyle(alignment: Alignment.bottomLeft),
      // Todo: update state based on selection
      // onSelected: () {},
    );
  }
}
