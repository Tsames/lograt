import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/workout_log/workout_log_state.dart';

import '../../../data/entities/workout.dart';

class WorkoutLog extends StatefulWidget {
  final Workout workout;

  const WorkoutLog(this.workout, {super.key});

  @override
  State<WorkoutLog> createState() => WorkoutLogState();
}
