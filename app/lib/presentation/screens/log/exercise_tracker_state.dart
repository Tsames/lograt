import 'package:flutter/material.dart';
// import 'package:lograt/domain/entities/exercise.dart';

import '../../../domain/entities/exercise_type.dart';
import 'exercise_tracker.dart';

class ExerciseTrackerState extends State<ExerciseTracker> {
  late ExerciseType? selectedExerciseType = widget.exercise.exerciseType;

  @override
  Widget build(BuildContext context) {
    return Placeholder();
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     // Exercise type dropdown
    //     DropdownButtonFormField<ExerciseType>(
    //       initialValue: selectedExerciseType,
    //       decoration: const InputDecoration(labelText: 'Exercise', border: OutlineInputBorder()),
    //       items: widget.availableExerciseTypes
    //           .map((type) => DropdownMenuItem(value: type, child: Text(type.name)))
    //           .toList(),
    //       onChanged: (value) {
    //         setState(() {
    //           selectedExerciseType = value;
    //         });
    //       },
    //     ),
    //     const SizedBox(height: 16),
    //   ],
    // );
  }
}
