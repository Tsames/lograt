import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/util/human_friendly_date_format.dart';

import '../../providers/workout_provider.dart';
import '../log/workout_log.dart';

class WorkoutHistory extends ConsumerWidget {
  const WorkoutHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutHistoryState = ref.watch(workoutListProvider);
    // final workoutHistoryNotifier = ref.read(workoutListProvider.notifier);

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
            onPressed: () =>
                ref.read(workoutListProvider.notifier).loadWorkouts(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    // Handle loading state with existing data
    if (workoutHistoryState.isLoading && workoutHistoryState.workouts.isEmpty) {
      return const CircularProgressIndicator();
    }

    // Handle empty state
    if (workoutHistoryState.workouts.isEmpty) {
      return const Text("No workouts yet.", style: TextStyle(fontSize: 18));
    }

    // Display workout list
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: workoutHistoryState.workouts.length,
      itemBuilder: (context, index) {
        final workout = workoutHistoryState.workouts[index];
        return ListTile(
          title: Text(workout.name),
          subtitle: Text(workout.createdOn.toHumanFriendlyFormat()),
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
