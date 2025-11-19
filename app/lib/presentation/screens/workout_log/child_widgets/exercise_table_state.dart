import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_table_widget.dart';

import '../../../../data/entities/set_type.dart';
import '../../../../data/entities/units.dart';
import '../view_model/workout_log_notifier.dart';

class ExerciseTableState extends ConsumerState<ExerciseTableWidget> {
  late bool _showNotes =
      widget.exercise.notes != null && widget.exercise.notes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    print(widget.exercise.notes);

    final sets = ref.watch(
      workoutLogProvider(widget.workout).select(
        (state) => state.workout.exercises
            .firstWhere((e) => e.id == widget.exercise.id)
            .sets,
      ),
    );

    final workoutLogNotifier = ref.read(
      workoutLogProvider(widget.workout).notifier,
    );
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
                        widget.exercise.id,
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
                          widget.exercise.id,
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
                        widget.exercise.id,
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
                          widget.exercise.id,
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: 20),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _showNotes
              ? Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Notes',
                        hintStyle: theme.textTheme.bodyMedium,
                      ),
                      style: theme.textTheme.bodyMedium,
                      controller: TextEditingController(
                        text: widget.exercise.notes,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Todo: make this button toggle an interface for notes on and off
            // Todo: make it animated!
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                key: ValueKey<bool>(_showNotes),
                onPressed: () {
                  setState(() {
                    _showNotes = !_showNotes;
                  });
                },
                icon: Icon(
                  _showNotes
                      ? Icons.mode_comment_rounded
                      : Icons.mode_comment_outlined,
                  size: 18,
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  workoutLogNotifier.addSetToExercise(widget.exercise.id),
              icon: const Icon(Icons.add, size: 18),
            ),
            IconButton(
              onPressed: () => workoutLogNotifier.removeLastSetFromExercise(
                widget.exercise.id,
              ),
              icon: const Icon(Icons.remove, size: 18),
            ),
            IconButton(
              onPressed: () => workoutLogNotifier.duplicateLastSetOfExercise(
                widget.exercise.id,
              ),
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
