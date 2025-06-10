import 'models/workout.dart';

class WorkoutSeed {
  static List<Workout> sampleWorkouts = [
    Workout(id: 1, name: 'Recovery Yoga', createdOn: DateTime.now().subtract(const Duration(days: 6))),
    Workout(id: 2, name: 'Morning HIIT', createdOn: DateTime.now()),
    Workout(id: 3, name: 'Leg Day', createdOn: DateTime.now().subtract(const Duration(days: 1))),
    Workout(id: 4, name: 'Cardio Session', createdOn: DateTime.now().subtract(const Duration(days: 5))),
    Workout(id: 5, name: 'Upper Body Strength', createdOn: DateTime.now().subtract(const Duration(days: 2))),
    Workout(id: 6, name: 'Full Body Circuit', createdOn: DateTime.now().subtract(const Duration(days: 4))),
    Workout(id: 7, name: 'Core Blast', createdOn: DateTime.now().subtract(const Duration(days: 3))),
  ];
}
