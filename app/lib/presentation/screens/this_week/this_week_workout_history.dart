import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/util/human_friendly_date_format.dart';

import '../log/workout_log.dart';
import 'this_week_workout_history_provider.dart';

class ThisWeekWorkoutHistory extends ConsumerWidget {
  const ThisWeekWorkoutHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final thisWeekWorkoutHistoryState = ref.watch(
      thisWeekWorkoutHistoryProvider,
    );
    late final thisWeekWorkoutHistoryNotifier = ref.read(
      thisWeekWorkoutHistoryProvider.notifier,
    );

    final textTheme = Theme.of(context).textTheme;
    final workouts = thisWeekWorkoutHistoryState.workoutsThisWeek;

    return SafeArea(
      child: Column(
        children: () {
          if (thisWeekWorkoutHistoryState.error != null) {
            return [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${thisWeekWorkoutHistoryState.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          thisWeekWorkoutHistoryNotifier.loadWorkouts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ];
          }

          // Handle loading state with existing data
          if (thisWeekWorkoutHistoryState.isLoading && workouts.isEmpty) {
            return [const CircularProgressIndicator()];
          }

          // Handle empty state
          if (workouts.isEmpty) {
            return const [
              Text("No workouts yet.", style: TextStyle(fontSize: 18)),
            ];
          }

          return [
            Text("This Week", style: textTheme.bodyMedium),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(workout.name, style: textTheme.bodyLarge),
                  subtitle: Text(
                    workout.createdOn.toHumanFriendlyFormat(),
                    style: textTheme.labelSmall,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutLog(workout),
                      ),
                    );
                  },
                );
              },
            ),
          ];
        }(),
      ),
    );
  }
}
