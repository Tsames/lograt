import '../models/workout_model.dart';

class WorkoutSeed {
  static List<WorkoutModel> sampleWorkouts = [
    WorkoutModel(name: 'Recovery Yoga', createdOn: DateTime.now().subtract(const Duration(days: 6))),
    WorkoutModel(name: 'Morning HIIT', createdOn: DateTime.now()),
    WorkoutModel(name: 'Leg Day', createdOn: DateTime.now().subtract(const Duration(days: 1))),
    WorkoutModel(name: 'Cardio Session', createdOn: DateTime.now().subtract(const Duration(days: 5))),
    WorkoutModel(name: 'Upper Body Strength', createdOn: DateTime.now().subtract(const Duration(days: 2))),
    WorkoutModel(name: 'Full Body Circuit', createdOn: DateTime.now().subtract(const Duration(days: 4))),
    WorkoutModel(name: 'Core Blast', createdOn: DateTime.now().subtract(const Duration(days: 3))),
  ];
}
