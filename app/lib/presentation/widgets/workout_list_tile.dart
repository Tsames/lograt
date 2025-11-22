import 'package:flutter/material.dart';
import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

class WorkoutListTile extends StatelessWidget {
  final Workout workout;

  const WorkoutListTile(this.workout, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      title: Text(workout.title ?? 'New Workout', style: textTheme.bodyLarge),
      subtitle: Text(
        workout.date.toHumanFriendlyFormat(),
        style: textTheme.labelSmall,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutLogWidget(workout)),
        );
      },
    );
  }
}
