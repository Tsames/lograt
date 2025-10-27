import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/this_week_tab/this_week_workout_history.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lograt',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.view_week), text: "This Week"),
                Tab(icon: Icon(Icons.history), text: "History"),
                Tab(icon: Icon(Icons.settings), text: "Settings"),
              ],
            ),
          ),
          body: TabBarView(
            children: [ThisWeekWorkoutHistory(), Placeholder(), Placeholder()],
          ),
        ),
      ),
    );
  }
}
