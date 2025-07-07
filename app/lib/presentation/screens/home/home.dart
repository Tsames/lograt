import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/workout_history.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: WorkoutHistory()),
      ),
    );
  }
}
