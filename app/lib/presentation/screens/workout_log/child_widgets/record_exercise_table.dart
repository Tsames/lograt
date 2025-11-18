import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier.dart';

import '../../../../data/entities/set_type.dart';
import '../../../../data/entities/units.dart';
import '../../../../data/entities/workout.dart';

class ExerciseTable extends ConsumerWidget {
  final Workout workout;
  final String exerciseId;

  const ExerciseTable(this.workout, this.exerciseId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sets = ref.watch(
      workoutLogProvider(workout).select(
        (state) =>
            state.workout.exercises.firstWhere((e) => e.id == exerciseId).sets,
      ),
    );
    final workoutLogNotifier = ref.read(workoutLogProvider(workout).notifier);
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
            ...sets.asMap().entries.map((entry) {
              final set = entry.value;
              return TableRow(
                children: [
                  DropdownMenu<SetType>(
                    hintText: "--",
                    initialSelection: set.setType,
                    dropdownMenuEntries: SetType.values.map((setType) {
                      return DropdownMenuEntry(
                        value: setType,
                        label: setType.name,
                      );
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                    ),
                    textStyle: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    onSelected: (SetType? valueChanged) {
                      workoutLogNotifier.updateSet(
                        set.copyWith(setType: valueChanged),
                        exerciseId,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: set.weight != null ? set.weight.toString() : "-",
                      ),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      // Todo: update state based on selection
                      onChanged: (String valueChanged) {
                        workoutLogNotifier.updateSet(
                          set.copyWith(
                            weight: switch (valueChanged) {
                              "" => null,
                              _ => double.parse(valueChanged),
                            },
                          ),
                          exerciseId,
                        );
                      },
                    ),
                  ),
                  DropdownMenu<Units>(
                    hintText: "--",
                    initialSelection: set.units,
                    dropdownMenuEntries: Units.values.map((setType) {
                      return DropdownMenuEntry(
                        value: setType,
                        label: setType.abbreviation,
                      );
                    }).toList(),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                    ),
                    textStyle: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                    showTrailingIcon: false,
                    // Todo: update state based on selection
                    onSelected: (Units? valueChanged) {
                      workoutLogNotifier.updateSet(
                        set.copyWith(units: valueChanged),
                        exerciseId,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.bodySmall,
                      controller: TextEditingController(
                        text: set.reps != null ? set.reps.toString() : "-",
                      ),
                      textAlign: TextAlign.center,
                      // Todo: update state based on selection
                      onChanged: (String valueChanged) {
                        workoutLogNotifier.updateSet(
                          set.copyWith(
                            reps: switch (valueChanged) {
                              "" => null,
                              _ => int.parse(valueChanged),
                            },
                          ),
                          exerciseId,
                        );
                      },
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
            // Todo: make this button toggle an interface for notes on and off
            // Todo: make it animated!
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mode_comment_rounded, size: 18),
            ),
            IconButton(
              onPressed: () => workoutLogNotifier.addSetToExercise(exerciseId),
              icon: const Icon(Icons.add, size: 18),
            ),
            IconButton(
              onPressed: () =>
                  workoutLogNotifier.removeLastSetFromExercise(exerciseId),
              icon: const Icon(Icons.remove, size: 18),
            ),
            IconButton(
              onPressed: () =>
                  workoutLogNotifier.duplicateLastSetOfExercise(exerciseId),
              icon: const Icon(Icons.copy, size: 18),
            ),
            //todo: add an undo button to undo the last action the user took
            // IconButton(onPressed: () => {}, icon: const Icon(Icons.undo_rounded)),
          ],
        ),
      ],
    );
  }
}
