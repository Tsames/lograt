import 'package:flutter/material.dart';
import 'package:lograt/presentation/tabs/app_tab.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/workout_history_tab_widget.dart';

class WorkoutHistoryTab implements AppTab {
  @override
  final title = 'History';

  @override
  final icon = Icons.history;

  @override
  Widget get widget => WorkoutHistoryTabWidget();

  WorkoutHistoryTab();
}
