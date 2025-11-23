import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: WorkoutHistoryWidget()));
  }
}
