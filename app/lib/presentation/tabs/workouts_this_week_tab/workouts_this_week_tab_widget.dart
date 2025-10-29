import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/widgets/workout_list_tile.dart';

import 'workouts_this_week_tab_provider.dart';

class WorkoutsThisWeekTabWidget extends ConsumerWidget {
  const WorkoutsThisWeekTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final workoutsThisWeekTabState = ref.watch(
      workoutsThisWeekTabProvider,
    );
    late final thisWeekWorkoutHistoryNotifier = ref.read(
      workoutsThisWeekTabProvider.notifier,
    );

    final textTheme = Theme.of(context).textTheme;
    final workouts = workoutsThisWeekTabState.workoutsThisWeek;

    return SafeArea(
      child: () {
        if (workoutsThisWeekTabState.error != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${workoutsThisWeekTabState.error}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => thisWeekWorkoutHistoryNotifier.loadWorkouts(),
                child: const Text('Retry'),
              ),
            ],
          );
        }

        // Handle loading state with existing data
        if (workoutsThisWeekTabState.isLoading && workouts.isEmpty) {
          return Center(child: const CircularProgressIndicator());
        }

        // Handle empty state
        if (workouts.isEmpty) {
          return Center(
            child: const Text(
              "No workouts yet.",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            Text("This Week", style: textTheme.headlineSmall),
            Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  return WorkoutListTile(workouts[index]);
                },
              ),
            ),
          ],
        );
      }(),
    );
  }
}
