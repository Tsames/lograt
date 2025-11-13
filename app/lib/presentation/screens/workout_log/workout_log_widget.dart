import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/record_exercise_table.dart';
import 'package:lograt/presentation/screens/workout_log/record_exercise_type_widget.dart';
import 'package:lograt/presentation/screens/workout_log/view_model/workout_log_notifier.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

import '../../../data/entities/workout.dart';

class WorkoutLogWidget extends ConsumerWidget {
  final Workout workout;

  const WorkoutLogWidget(this.workout, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutLogState = ref.watch(workoutLogProvider(workout));
    final workoutLogNotifier = ref.watch(workoutLogProvider(workout).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutLogState.workout.title ?? "New Workout"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(workoutLogState.workout.date.toHumanFriendlyFormat()),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: workoutLogState.workout.exercises.map((exercise) {
              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          RecordExerciseTypeWidget(exercise.exerciseType),
                          RecordExerciseTable(exercise, workoutLogNotifier),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
