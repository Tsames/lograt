import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lograt/presentation/screens/workout_log/record_exercise_type_widget.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

import '../../../data/entities/workout.dart';

class WorkoutLogWidget extends ConsumerWidget {
  final Workout workout;

  const WorkoutLogWidget(this.workout, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(workout.createdOn.toHumanFriendlyFormat()),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(children: [RecordExerciseTypeWidget()]),
      ),
    );
  }
}
