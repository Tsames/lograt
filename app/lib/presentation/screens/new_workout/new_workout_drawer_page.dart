import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';
import 'package:lograt/presentation/screens/new_workout/new_workout_widget.dart';

class NewWorkoutDrawerPage extends AppDrawerPage {
  void Function<T>() onCreateWorkout;

  NewWorkoutDrawerPage({required this.onCreateWorkout});

  @override
  final appBarTitle = 'Create Workout';

  @override
  final drawerTitle = 'New Workout';

  @override
  final icon = Icons.create;

  @override
  Widget get page => NewWorkoutWidget(onCreateWorkout);
}
