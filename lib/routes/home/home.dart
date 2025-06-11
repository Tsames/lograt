import 'package:flutter/material.dart';
import 'package:lograt/repository/services/WorkoutService.dart';
import 'package:lograt/repository/workout_seed.dart';

import '../../common/design/app_colors.dart';
import '../../repository/models/workout.dart';

class Home extends StatefulWidget {
  final List<Workout> workouts;

  const Home({super.key, required this.workouts});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Workout> _workoutData = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await WorkoutService.instance.getWorkouts();
    setState(() {
      _workoutData = workouts..sort((a, b) => b.createdOn.compareTo(a.createdOn));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.manilla,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purple,
        child: const Icon(Icons.refresh, color: AppColors.white),
        onPressed: () async {
          if (_workoutData.length > 0) {
            await WorkoutService.instance.clearTable();
          } else {
            await WorkoutService.instance.insertWorkout(WorkoutSeed.sampleWorkouts[0]);
            await WorkoutService.instance.insertWorkout(WorkoutSeed.sampleWorkouts[1]);
            await WorkoutService.instance.insertWorkout(WorkoutSeed.sampleWorkouts[2]);
            await WorkoutService.instance.insertWorkout(WorkoutSeed.sampleWorkouts[3]);
          }
          _loadWorkouts();
        },
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: _workoutData.isEmpty
              ? const Text("No workouts yet.", style: TextStyle(fontSize: 18))
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _workoutData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(_workoutData[index].name),
                        subtitle: Text(_workoutData[index].createdOn.toString()),
                        onTap: () {
                          // TODO Handle workout selection
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
