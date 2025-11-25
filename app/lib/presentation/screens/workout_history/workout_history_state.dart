import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier_state.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

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
        child: Text('Error: $error', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error)),
      ),
      WorkoutHistoryNotifierState(isLoading: true, workouts: []) => Center(child: const CircularProgressIndicator()),
      WorkoutHistoryNotifierState(workouts: []) => Center(
        child: const Text('No workouts yet.', style: TextStyle(fontSize: 18)),
      ),
      _ => () {
        final thisWeek = notifier.getWorkoutsThisWeek();
        final thisMonth = notifier.getWorkoutsThisMonthExcludingThisWeek();
        final lastThreeMonths = notifier.getWorkoutsLastThreeMonthsExcludingThisMonth();

        final items = [
          if (thisWeek.isNotEmpty) ...['This Week', ...thisWeek],
          if (thisMonth.isNotEmpty) ...['This Month', ...thisMonth],
          if (lastThreeMonths.isNotEmpty) ...['Last 3 Months', ...lastThreeMonths],
        ];

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  switch (items[index]) {
                    case Workout workout:
                      return ListTile(
                        title: Text(workout.title ?? 'New Workout', style: theme.textTheme.bodyLarge),
                        subtitle: Text(workout.date.toHumanFriendlyFormat(), style: theme.textTheme.labelSmall),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutLogWidget(workout)));
                        },
                      );
                    case String title:
                      return Column(
                        children: [
                          SizedBox(height: 20),
                          Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
                          Divider(thickness: 1, indent: 40, endIndent: 40),
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
