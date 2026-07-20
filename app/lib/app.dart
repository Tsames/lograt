import 'package:flutter/material.dart';
import 'package:lograt/util/extensions/muscle_groups_colors_theme_extension.dart';

class App extends StatefulWidget {
  const App({super.key});

  static const workoutHistory = '/workout-history';

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final appNavKey = GlobalKey<NavigatorState>();

  NavigatorState? get appNavigator => appNavKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lograt',
      navigatorKey: appNavKey,
      // navigatorObservers: [NavigatorObserver()],
      routes: {App.workoutHistory: (context) => Placeholder()},
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade700),
        useMaterial3: true,
        extensions: [MuscleGroupColorsThemeExtension.light()],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade700,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: [MuscleGroupColorsThemeExtension.dark()],
      ),
      home: Placeholder(),
    );
  }
}
