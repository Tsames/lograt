import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_widget.dart';

class WorkoutHistoryDrawerPage extends AppDrawerPage {
  @override
  final appBarTitle = 'Workout History';

  @override
  final drawerTitle = 'Workout History';

  @override
  final icon = Icons.history;

  @override
  Widget get page => WorkoutHistoryWidget();
}
