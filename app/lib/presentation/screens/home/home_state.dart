import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lograt/presentation/screens/home/app_drawer_page.dart';
import 'package:lograt/presentation/screens/home/home_widget.dart';
import 'package:lograt/presentation/screens/workout_history/workout_history_drawer_page.dart';

class HomeState extends State<HomeWidget> {
  int _selectedIndex = 0;
  late final List<AppDrawerPage> _pages = [WorkoutHistoryDrawerPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_selectedIndex].appBarTitle)),
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  },
                );
              }).toList(),
            ),
          ],
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
