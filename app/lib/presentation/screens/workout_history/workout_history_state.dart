import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier_state.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';
import 'package:lograt/util/workout_history_section_header.dart';

class WorkoutHistoryState extends ConsumerState<WorkoutHistoryWidget> {
  late final notifier = ref.read(workoutHistoryProvider.notifier);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 50;

      if (currentScroll > maxScroll - delta) {
        notifier.loadPaginatedWorkouts();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutHistoryProvider.notifier).loadPaginatedWorkouts();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutHistoryState = ref.watch(workoutHistoryProvider);
    final theme = Theme.of(context);

    return switch (workoutHistoryState) {
      WorkoutHistoryNotifierState(error: final error?) => Center(
        child: Text(
          'Error: $error',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
      WorkoutHistoryNotifierState(
        isLoading: true,
        workoutsWithSectionHeaders: final workouts,
      )
          when workouts.isEmpty =>
        Center(child: const CircularProgressIndicator()),
      WorkoutHistoryNotifierState(
        isLoading: false,
        workoutsWithSectionHeaders: final workouts,
      )
          when workouts.isEmpty =>
        Center(
          child: const Text('No workouts yet.', style: TextStyle(fontSize: 18)),
        ),
      _ => () {
        final workouts = workoutHistoryState.workoutsWithSectionHeaders;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  switch (workouts[index]) {
                    case Workout workout:
                      return Dismissible(
                        key: Key(workout.id),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Delete Workout',
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'Are you sure you want to delete:',
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\n\n${workout.title}\n${workout.date.toLongFriendlyFormat()}',
                                                style: TextStyle(
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\n\nYou cannot undo this action.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (direction == DismissDirection.startToEnd) {
                            // Todo: Navigate to new duplicated workout
                            return false; // Don't dismiss, just animate back
                          }
                          return false;
                        },
                        background: Container(
                          // Shows when swiping right
                          color: theme.colorScheme.primary,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.copy,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        secondaryBackground: Container(
                          // Shows when swiping left
                          color: theme.colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.delete,
                            color: theme.colorScheme.onError,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutLogWidget(workout),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workout.title ?? 'Unnamed Workout',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      workout.date.toLongFriendlyFormat(),
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                                if (workout.muscleGroups.isNotEmpty) ...[
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        const minChipWidth = 40.0;
                                        const chipSpacing = 4.0;

                                        final maxPossibleChips =
                                            (constraints.maxWidth /
                                                    (minChipWidth +
                                                        chipSpacing))
                                                .floor();
                                        final chipsToShow = maxPossibleChips
                                            .clamp(
                                              1,
                                              workout.muscleGroups.length,
                                            );

                                        final List<String> chipTexts;
                                        if (chipsToShow <
                                            workout.muscleGroups.length) {
                                          // Show some chips + overflow indicator
                                          chipTexts =
                                              workout.muscleGroups
                                                  .take(chipsToShow - 1)
                                                  .map((mg) => mg.label)
                                                  .toList()
                                                ..add(
                                                  '+${workout.muscleGroups.length - (chipsToShow - 1)}',
                                                );
                                        } else {
                                          // Show all chips
                                          chipTexts = workout.muscleGroups
                                              .map((mg) => mg.label)
                                              .toList();
                                        }

                                        // Max width for each chip (distribute available space)
                                        final maxChipWidth =
                                            (constraints.maxWidth -
                                                (chipTexts.length - 1) *
                                                    chipSpacing) /
                                            chipTexts.length;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 4,
                                          children: chipTexts
                                              .map(
                                                (chipText) => Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: maxChipWidth,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: switch (chipText) {
                                                      'Chest' => Color(
                                                        0xFF733D3B,
                                                      ),
                                                      'Shoulders' => Color(
                                                        0xFF9E6F3C,
                                                      ),
                                                      'Arms' => Color(
                                                        0xFF887634,
                                                      ),
                                                      'Back' => Color(
                                                        0xFF3F7135,
                                                      ),
                                                      'Core' => Color(
                                                        0xFF2A4B65,
                                                      ),
                                                      'Legs' => Color(
                                                        0xFF492D60,
                                                      ),
                                                      _ => Color(0xFF2E2D2D),
                                                    },
                                                  ),
                                                  child: Text(
                                                    chipText,
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontSize: 10,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    case WeekWorkoutHistorySectionHeader header:
                      return Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 4),
                        child: Text(
                          header.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    case WorkoutHistorySectionHeader header:
                      return Column(
                        children: [
                          if (index > 0) SizedBox(height: 30),
                          Text(
                            header.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Divider(thickness: 1, indent: 40, endIndent: 40),
                          if (index == 0) SizedBox(height: 30),
                        ],
                      );
                    default:
                      return null;
                  }
                },
                controller: scrollController,
              ),
            ),
          ],
        );
      }(),
    };
  }
}
