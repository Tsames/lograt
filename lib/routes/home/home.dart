import 'package:flutter/material.dart';

import '../../common/design/app_colors.dart';
import '../../repository/models/workout.dart';

class Home extends StatelessWidget {
  final List<Workout> workouts;

  const Home({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: AppBar(), backgroundColor: AppColors.purple),
      backgroundColor: AppColors.manilla,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              // Sort workouts by date (most recent first)
              final sortedWorkouts = workouts..sort((a, b) => b.createdOn.compareTo(a.createdOn));
              final workout = sortedWorkouts[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(workout.createdOn.toString()),
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
