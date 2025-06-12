import 'package:flutter/material.dart';
import 'package:lograt/database/repositories/workout_repository.dart';
import 'package:lograt/database/workout_seed.dart';
import '../../common/design/app_colors.dart';
import '../../database/models/workout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Workout> _workoutData = [];
  final WorkoutRepository _repository = WorkoutRepository();

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _repository.getMostRecentWorkouts();
    setState(() {
      _workoutData = workouts;
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
          if (_workoutData.isNotEmpty) {
            await _repository.clearWorkouts();
          } else {
            await _repository.addWorkouts(WorkoutSeed.sampleWorkouts);
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
