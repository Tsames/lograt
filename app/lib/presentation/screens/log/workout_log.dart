import 'package:flutter/material.dart';
import 'package:lograt/domain/entities/workout.dart';
import 'package:lograt/presentation/screens/log/workout_log_state.dart';

class WorkoutLog extends StatefulWidget {
  final Workout workout;

  const WorkoutLog(this.workout, {super.key});

  @override
  State<WorkoutLog> createState() => WorkoutLogState();
}
