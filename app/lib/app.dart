import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lograt',
      routes: {'/workout-history': (context) => WorkoutHistoryWidget()},
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade200),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber.shade200,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: WorkoutHistoryWidget(),
    );
  }
}
