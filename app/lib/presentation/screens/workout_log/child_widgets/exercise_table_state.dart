import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_table_widget.dart';

import '../../../../data/entities/exercise_set.dart';
import '../../../../data/entities/set_type.dart';
import '../../../../data/entities/units.dart';
import '../view_model/workout_log_notifier.dart';

class ExerciseTableState extends ConsumerState<ExerciseTableWidget> {
  late bool _showNotes =
      widget.exercise.notes != null && widget.exercise.notes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
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
        // Set Fields Header
        Container(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Set Type",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Weight",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Units",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Reps",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sets
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              /*
                When moving a tab to the right, flutter thinks the tab being moved still occupies its old place in the list.
                This means the newIndex will be at one greater than the correct index, possibly even out of bounds, if not adjusted.
              */
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final ExerciseSet item = sets.removeAt(oldIndex);
              sets.insert(newIndex, item);
            });
          },
          children: sets.mapIndexed((index, set) {
            return Container(
              key: ValueKey(set.id),
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(
                  bottom: BorderSide(
                    width: 1,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownMenu<SetType>(
                      hintText: "--",
                      initialSelection: set.setType,
                      dropdownMenuEntries: SetType.values.map((setType) {
                        return DropdownMenuEntry(
                          value: setType,
                          label: setType.name,
                        );
                      }).toList(),
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                      showTrailingIcon: false,
                      onSelected: (SetType? valueChanged) {
                        workoutLogNotifier.updateSet(
                          set.copyWith(setType: valueChanged),
                          widget.exercise.id,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: set.weight != null
                              ? set.weight.toString()
                              : "-",
                        ),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        onChanged: (String valueChanged) {
                          workoutLogNotifier.updateSet(
                            set.copyWith(
                              weight: valueChanged.isEmpty
                                  ? null
                                  : double.parse(valueChanged),
                            ),
                            widget.exercise.id,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: DropdownMenu<Units>(
                      hintText: "--",
                      initialSelection: set.units,
                      dropdownMenuEntries: Units.values.map((units) {
                        return DropdownMenuEntry(
                          value: units,
                          label: units.abbreviation,
                        );
                      }).toList(),
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
                      showTrailingIcon: false,
                      onSelected: (Units? valueChanged) {
                        workoutLogNotifier.updateSet(
                          set.copyWith(units: valueChanged),
                          widget.exercise.id,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
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
                        onChanged: (String valueChanged) {
                          workoutLogNotifier.updateSet(
                            set.copyWith(
                              reps: valueChanged.isEmpty
                                  ? null
                                  : int.parse(valueChanged),
                            ),
                            widget.exercise.id,
                          );
                        },
                      ),
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      size: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
