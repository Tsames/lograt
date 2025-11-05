import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/view_model/workout_history_tab_notifier.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/workout_history_tab_widget.dart';
import 'package:lograt/presentation/widgets/workout_list_tile.dart';

class WorkoutHistoryTabState extends ConsumerState<WorkoutHistoryTabWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final workoutHistoryTabNotifier = ref.read(
        workoutHistoryTabProvider.notifier,
      );
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 50;

      if (currentScroll > maxScroll - delta) {
        workoutHistoryTabNotifier.loadPaginatedWorkouts();
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
    final workoutHistoryTabNotifier = ref.read(
      workoutHistoryTabProvider.notifier,
    );
    final workoutHistoryTabState = ref.watch(workoutHistoryTabProvider);
    final workouts = workoutHistoryTabState.sortedWorkouts;
    final textTheme = Theme.of(context).textTheme;

    if (workoutHistoryTabState.error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${workoutHistoryTabState.error}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => workoutHistoryTabNotifier.loadPaginatedWorkouts(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    // Handle loading state with existing data
    if (workoutHistoryTabState.isLoading && workouts.isEmpty) {
      return Center(child: const CircularProgressIndicator());
    }

    // Handle empty state
    if (workouts.isEmpty) {
      return Center(
        child: const Text("No workouts yet.", style: TextStyle(fontSize: 18)),
      );
    }

    return Column(
      children: [
        Text("Workout History", style: textTheme.headlineSmall),
        Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return WorkoutListTile(workouts[index]);
            },
            controller: scrollController,
          ),
        ),
      ],
    );
  }
}
