import 'package:flutter/material.dart';
import 'package:lograt/data/entities/exercise.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier.dart';

import '../../../data/entities/set_type.dart';
import '../../../data/entities/units.dart';

class RecordExerciseTable extends StatelessWidget {
  final Exercise exercise;
  final WorkoutLogNotifier notifier;

  const RecordExerciseTable(this.exercise, this.notifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(color: theme.colorScheme.secondary),
          children: [
            // Header row
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Set Type", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Weight", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Units", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Reps", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                ),
              ],
            ),
            ...exercise.sets.asMap().entries.map((entry) {
              final set = entry.value;
              return TableRow(
                children: [
                  DropdownMenu<SetType>(
                    hintText: "--",
                    initialSelection: set.setType,
                    dropdownMenuEntries: SetType.values.map((setType) {
                      return DropdownMenuEntry(value: setType, label: setType.name);
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
                    textStyle: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    // onSelected: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: set.reps.toString()),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      // Todo: update state based on selection
                      // onChanged: (value) {},
                    ),
                  ),
                  DropdownMenu<Units>(
                    hintText: "--",
                    initialSelection: set.units,
                    dropdownMenuEntries: Units.values.map((setType) {
                      return DropdownMenuEntry(value: setType, label: setType.abbreviation);
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
                    textStyle: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    // onSelected: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.bodySmall,
                      controller: TextEditingController(text: set.reps.toString()),
                      textAlign: TextAlign.center,
                      // Todo: update state based on selection
                      // onChanged: (value) {},
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () => notifier.addSetToExercise(exercise), icon: const Icon(Icons.add)),
            IconButton(onPressed: () => notifier.removeLastSetFromExercise(exercise), icon: const Icon(Icons.remove)),
            IconButton(onPressed: () => notifier.duplicateLastSetOfExercise(exercise), icon: const Icon(Icons.copy)),
            //todo: add an undo button to undo the last action the user took
            // IconButton(onPressed: () => {}, icon: const Icon(Icons.undo_rounded)),
          ],
        ),
      ],
    );
  }
}
