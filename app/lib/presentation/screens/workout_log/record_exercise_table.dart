import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/exercise.dart';

import '../../../data/entities/set_type.dart';
import '../../../data/entities/units.dart';

class RecordExerciseTable extends ConsumerWidget {
  final Exercise exercise;

  const RecordExerciseTable(this.exercise, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: Text(
                    "Set Type",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Weight",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Units",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Reps",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ...exercise.sets.asMap().entries.map((entry) {
              final set = entry.value;
              return TableRow(
                children: [
                  DropdownMenu<SetType>(
                    hintText: "--",
                    dropdownMenuEntries: SetType.values.map((setType) {
                      return DropdownMenuEntry(
                        value: setType,
                        label: setType.name,
                      );
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                    ),
                    textStyle: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    // onSelected: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: set.reps.toString(),
                      ),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      // Todo: update state based on selection
                      // onChanged: (value) {},
                    ),
                  ),
                  DropdownMenu<Units>(
                    hintText: "--",
                    dropdownMenuEntries: Units.values.map((setType) {
                      return DropdownMenuEntry(
                        value: setType,
                        label: setType.abbreviation,
                      );
                    }).toList(),
                    initialSelection: Units.pounds,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                    ),
                    textStyle: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    // onSelected: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.bodyMedium,
                      controller: TextEditingController(
                        text: set.reps.toString(),
                      ),
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
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Set'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.remove),
              label: const Text('Delete last set'),
            ),
          ],
        ),
      ],
    );
  }
}
