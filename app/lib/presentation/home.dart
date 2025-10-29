import 'package:flutter/material.dart';
import 'package:lograt/presentation/tabs/app_tab.dart';
import 'package:lograt/presentation/tabs/workout_history_tab/workout_history_tab.dart';
import 'package:lograt/presentation/tabs/workouts_this_week_tab/workouts_this_week_tab.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static final List<AppTab> tabs = [WorkoutsThisWeekTab(), WorkoutHistoryTab()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: tabs
                .map((tab) => Tab(icon: Icon(tab.icon), text: tab.title))
                .toList(),
          ),
        ),
        body: TabBarView(children: tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}
