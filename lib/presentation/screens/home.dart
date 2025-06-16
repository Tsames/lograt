import 'package:flutter/material.dart';
import 'package:lograt/data/repositories/workout_repository_impl.dart';
import 'package:lograt/di/service_locator.dart';
import '../../common/design/app_colors.dart';
import '../../data/models/workout_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Workout> _workouts = [];
  late WorkoutRepository _repository;

  @override
  void initState() {
    super.initState();

    _repository = serviceLocator<WorkoutRepository>();

    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _repository.getMostRecentWorkouts();
    setState(() {
      _workouts = workouts;
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
          if (_workouts.isNotEmpty) {
            await _repository.clearWorkouts();
          } else {
            await _repository.seedWorkouts();
          }
          _loadWorkouts();
        },
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: _workouts.isEmpty
              ? const Text("No workouts yet.", style: TextStyle(fontSize: 18))
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(_workouts[index].name),
                        subtitle: Text(_workouts[index].createdOn.toString()),
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
