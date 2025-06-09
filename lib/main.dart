import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lograt/repository/workout_seed.dart';
import 'package:lograt/routes/home/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const LogRatApp());
}

class LogRatApp extends StatelessWidget {
  const LogRatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lograt',
      home: Home(workouts: WorkoutSeed.sampleWorkouts),
    );
  }
}
