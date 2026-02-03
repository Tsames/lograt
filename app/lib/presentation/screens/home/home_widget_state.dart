import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';
import 'package:lograt/presentation/screens/home/home_widget.dart';
import 'package:lograt/presentation/screens/new_workout/new_workout_drawer_page.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_drawer_page.dart';

class HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 1;
  late final List<AppDrawerPage> _pages = [
    NewWorkoutDrawerPage(onCreateWorkout: _setSelectedPage),
    WorkoutHistoryDrawerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: switch (_pages[_selectedIndex]) {
          WorkoutHistoryDrawerPage _ => null,
          _ => IconButton(
            onPressed: _setSelectedPage<WorkoutHistoryDrawerPage>,
            icon: Icon(Icons.arrow_back_ios),
          ),
        },
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(_pages[_selectedIndex].appBarTitle),
        ),
      ),
      floatingActionButton: switch (_pages[_selectedIndex]) {
        WorkoutHistoryDrawerPage _ => FloatingActionButton(
          onPressed: _setSelectedPage<NewWorkoutDrawerPage>,
          child: Icon(Icons.create),
        ),
        _ => null,
      },
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
                      _setSelectedIndex(index);
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _pages[_selectedIndex].page,
            ),
          ),
        ),
      ),
    );
  }

  void _setSelectedPage<T>() {
    final indexOfPageOfType = _pages.indexWhere((page) => page is T);
    if (indexOfPageOfType == -1) {
      throw Exception(
        'Error when trying to set home page state to a page of type $T. No page of type $T exists.',
      );
    }
    setState(() {
      _selectedIndex = indexOfPageOfType;
    });
  }

  void _setSelectedIndex(int newIndex) {
    if (newIndex < 0 || newIndex >= _pages.length) {
      throw Exception(
        'New selected index, $newIndex, is out of bounds. Pages has length ${_pages.length}.',
      );
    }
    setState(() {
      _selectedIndex = newIndex;
    });
  }
}
