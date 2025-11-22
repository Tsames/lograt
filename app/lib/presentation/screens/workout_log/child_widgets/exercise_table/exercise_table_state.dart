import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/exercise_set.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/presentation/screens/workout_log/child_widgets/exercise_table/exercise_table_widget.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier.dart';

class ExerciseTableState extends ConsumerState<ExerciseTableWidget>
    with TickerProviderStateMixin {
  late final Map<String, AnimationController> _setAnimationControllers = {};
  late final Map<String, Animation<double>> _setAnimations = {};

  Set<String> _previousSetIds = {};

  @override
  void initState() {
    super.initState();
    _previousSetIds = widget.exercise.sets.map((s) => s.id).toSet();
  }

  @override
  void dispose() {
    for (final controller in _setAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint(
        'Building Exercise Table for exercise: ${widget.exercise.id} - order: ${widget.exercise.order}',
      );
    }

    final sets = ref.watch(
      workoutLogProvider(widget.workout).select(
        (state) => state.workout.exercises
            .firstWhere((e) => e.id == widget.exercise.id)
            .sets,
      ),
    );

    final currentSetIds = sets.map((s) => s.id).toSet();

    for (final set in sets) {
      if (!_setAnimationControllers.containsKey(set.id)) {
        // Determine if this is a new set
        final isNewSet = !_previousSetIds.contains(set.id);

        _setAnimationControllers[set.id] = AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: this,
          value: isNewSet
              ? 0.0
              : 1.0, // Start at 0 for new sets, 1 for existing
        );

        _setAnimations[set.id] = CurvedAnimation(
          parent: _setAnimationControllers[set.id]!,
          curve: Curves.easeInOutCubic,
        );

        // Animate in if it's a new set
        if (isNewSet) {
          _setAnimationControllers[set.id]!.forward();
        }
      }
    }

    _previousSetIds = currentSetIds;

    final workoutLogNotifier = ref.read(
      workoutLogProvider(widget.workout).notifier,
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // <><><><><> Set Fields Header <><><><><>
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              bottom: BorderSide(width: 1, color: theme.colorScheme.secondary),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Set Type',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Weight',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Units',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Reps',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // <><><><><> Sets <><><><><>
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
            final animationController = _setAnimationControllers[set.id];
            return SizeTransition(
              key: ValueKey(set.id),
              sizeFactor: _setAnimations[set.id]!,
              child: Dismissible(
                key: Key(set.id),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Swipe left - delete
                    await animationController?.reverse();
                    workoutLogNotifier.removeSetFromExercise(
                      widget.exercise.id,
                      index,
                    );

                    // Remove Controller and animation from state maps
                    _setAnimationControllers.remove(set.id)?.dispose();
                    _setAnimations.remove(set.id);

                    return true; // Allow dismissal
                  } else if (direction == DismissDirection.startToEnd) {
                    // Swipe right - duplicate
                    workoutLogNotifier.duplicateSetOfExercise(
                      widget.exercise.id,
                      index,
                    );
                    return false; // Don't dismiss, just animate back
                  }
                  return false;
                },
                background: Container(
                  // Shows when swiping right
                  color: theme.colorScheme.primary,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.copy, color: theme.colorScheme.onPrimary),
                ),
                secondaryBackground: Container(
                  // Shows when swiping left
                  color: theme.colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: theme.colorScheme.onError),
                ),
                child: Container(
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
                          hintText: '-',
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
                              widget.exercise.id,
                              set.copyWith(setType: valueChanged),
                              index,
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
                                  : '-',
                            ),
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            onSubmitted: (String valueChanged) {
                              workoutLogNotifier.updateSet(
                                widget.exercise.id,
                                set.copyWith(
                                  weight: valueChanged.isEmpty
                                      ? null
                                      : double.parse(valueChanged),
                                ),
                                index,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownMenu<Units>(
                          hintText: '-',
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
                              widget.exercise.id,
                              set.copyWith(units: valueChanged),
                              index,
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
                              text: set.reps != null
                                  ? set.reps.toString()
                                  : '-',
                            ),
                            textAlign: TextAlign.center,
                            onSubmitted: (String valueChanged) {
                              workoutLogNotifier.updateSet(
                                widget.exercise.id,
                                set.copyWith(
                                  reps: valueChanged.isEmpty
                                      ? null
                                      : int.parse(valueChanged),
                                ),
                                index,
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
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
