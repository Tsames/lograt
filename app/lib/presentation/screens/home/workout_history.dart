import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/util/human_friendly_date_format.dart';

import '../../providers/workout_history_provider.dart';
import '../log/workout_log.dart';

class WorkoutHistory extends ConsumerWidget {
  const WorkoutHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    late final workoutHistoryState = ref.watch(workoutHistoryProvider);
    late final workoutHistoryNotifier = ref.read(
      workoutHistoryProvider.notifier,
    );

    final workouts = workoutHistoryState.workouts;

    // Handle error state
    if (workoutHistoryState.error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${workoutHistoryState.error}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => workoutHistoryNotifier.loadWorkouts(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    // Handle loading state with existing data
    if (workoutHistoryState.isLoading && workouts.isEmpty) {
      return const CircularProgressIndicator();
    }

    // Handle empty state
    if (workouts.isEmpty) {
      return const Text("No workouts yet.", style: TextStyle(fontSize: 18));
    }

    // Display workout list
    return ListView.builder(
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
              MaterialPageRoute(builder: (context) => WorkoutLog(workout)),
            );
          },
        );
      },
    );
  }
}
