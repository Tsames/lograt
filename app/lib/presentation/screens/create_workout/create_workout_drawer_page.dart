import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/create_workout/create_workout_widget.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';

class CreateWorkoutDrawerPage extends AppDrawerPage {
  void Function<T>() onCreateWorkout;

  CreateWorkoutDrawerPage({required this.onCreateWorkout});

  @override
  final appBarTitle = 'Create Workout';

  @override
  final drawerTitle = 'New Workout';

  @override
  final icon = Icons.create;

  @override
  Widget get page => CreateWorkoutWidget(onCreateWorkout);
}
