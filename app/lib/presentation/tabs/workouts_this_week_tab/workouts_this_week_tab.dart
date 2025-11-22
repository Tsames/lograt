import 'package:flutter/material.dart';
import 'package:lograt/presentation/tabs/app_tab.dart';
import 'package:lograt/presentation/tabs/workouts_this_week_tab/workouts_this_week_tab_widget.dart';

class WorkoutsThisWeekTab implements AppTab {
  @override
  final title = 'This Week';

  @override
  final icon = Icons.view_week;

  @override
  Widget get widget => WorkoutsThisWeekTabWidget();

  WorkoutsThisWeekTab();
}
