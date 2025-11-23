import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/presentation/screens/workout_history/view_model/workout_history_notifier.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';
import 'package:lograt/presentation/widgets/workout_list_tile.dart';

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
    final textTheme = Theme.of(context).textTheme;

    if (workoutHistoryState.error != null) {
      return Center(
        child: Text(
          'Error: ${workoutHistoryState.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // Handle loading state with existing data
    if (workoutHistoryState.isLoading && workoutHistoryState.workouts.isEmpty) {
      return Center(child: const CircularProgressIndicator());
    }

    // Handle empty state
    if (workoutHistoryState.workouts.isEmpty) {
      return Center(
        child: const Text('No workouts yet.', style: TextStyle(fontSize: 18)),
      );
    }

    final thisWeek = notifier.getWorkoutsThisWeek();
    final thisMonth = notifier.getWorkoutsThisMonthExcludingThisWeek();
    final lastThreeMonths = notifier
        .getWorkoutsLastThreeMonthsExcludingThisMonth();

    final items = [
      if (thisWeek.isNotEmpty) ...['This Week', ...thisWeek],
      if (thisMonth.isNotEmpty) ...['This Month', ...thisMonth],
      if (lastThreeMonths.isNotEmpty) ...['Last 3 Months', ...lastThreeMonths],
    ];

    return Column(
      children: [
        Text('Workout History', style: textTheme.headlineSmall),
        Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              switch (items[index]) {
                case Workout workout:
                  return WorkoutListTile(workout);
                case String title:
                  return Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge,
                      ),
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
  }
}
