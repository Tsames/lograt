import 'package:flutter/material.dart';

import '../../common/design/app_colors.dart';
import '../../repository/models/workout.dart';

class Home extends StatelessWidget {
  final List<Workout> workouts;

  const Home({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.manilla,
        body: const Center(child: Text("No Data available.", style: TextStyle(fontSize: 18))),
      );
    }

    final sortedWorkouts = workouts..sort((a, b) => b.createdOn.compareTo(a.createdOn));

    return Scaffold(
      backgroundColor: AppColors.manilla,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(sortedWorkouts[index].name),
                  subtitle: Text(sortedWorkouts[index].createdOn.toString()),
                  onTap: () {
                    // Handle workout selection
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
