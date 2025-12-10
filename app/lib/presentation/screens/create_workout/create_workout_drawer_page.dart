import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';

class CreateWorkoutDrawerPage extends AppDrawerPage {
  @override
  final appBarTitle = 'Create a Workout';

  @override
  final drawerTitle = 'New Workout';

  @override
  final icon = Icons.add;

  @override
  Widget get page => Placeholder();
}
