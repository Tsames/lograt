import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/home_widget.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const workoutHistory = '/workout-history';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lograt',
      routes: {workoutHistory: (context) => WorkoutHistoryWidget()},
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade700),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade700,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeWidget(),
    );
  }
}
