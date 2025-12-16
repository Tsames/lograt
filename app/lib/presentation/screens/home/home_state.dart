import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lograt/presentation/screens/create_workout/create_workout_drawer_page.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';
import 'package:lograt/presentation/screens/home/home_widget.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_drawer_page.dart';

class HomeState extends State<HomeWidget> {
  int _selectedIndex = 1;
  late final List<AppDrawerPage> _pages = [
    CreateWorkoutDrawerPage(),
    WorkoutHistoryDrawerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_selectedIndex].appBarTitle)),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svgs/lograt_icon.svg',
                semanticsLabel: 'Lograt logo',
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primaryFixedDim,
                  BlendMode.srcIn,
                ),
                width: 150,
                height: 150,
              ),
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: _pages.mapIndexed((index, drawerPage) {
                  return ListTile(
                    leading: Icon(drawerPage.icon),
                    title: Text(drawerPage.drawerTitle),
                    selected: _selectedIndex == index,
                    onTap: () {
                      if (index >= _pages.length) return;
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: _pages[_selectedIndex].page,
        ),
      ),
    );
  }
}
