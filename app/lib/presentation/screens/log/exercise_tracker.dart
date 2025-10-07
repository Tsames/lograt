import 'package:flutter/material.dart';

import '../../../domain/entities/exercise.dart';
import 'exercise_tracker_state.dart';

class ExerciseTracker extends StatefulWidget {
  final Exercise exercise;
  const ExerciseTracker(this.exercise, {super.key});

  @override
  State<ExerciseTracker> createState() => ExerciseTrackerState();
}
