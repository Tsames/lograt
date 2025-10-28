import 'package:flutter/material.dart';
import 'package:lograt/domain/entities/workout.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

import '../screens/workout_log/workout_log.dart';

class WorkoutListTile extends StatelessWidget {
  final Workout workoutData;

  const WorkoutListTile(this.workoutData, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      title: Text(workoutData.name, style: textTheme.bodyLarge),
      subtitle: Text(
        workoutData.createdOn.toHumanFriendlyFormat(),
        style: textTheme.labelSmall,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutLog(workoutData)),
        );
      },
    );
  }
}
