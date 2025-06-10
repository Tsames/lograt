import 'models/workout.dart';

class WorkoutSeed {
  static List<Workout> sampleWorkouts = [
    Workout(name: 'Recovery Yoga', createdOn: DateTime.now().subtract(const Duration(days: 6))),
    Workout(name: 'Morning HIIT', createdOn: DateTime.now()),
    Workout(name: 'Leg Day', createdOn: DateTime.now().subtract(const Duration(days: 1))),
    Workout(name: 'Cardio Session', createdOn: DateTime.now().subtract(const Duration(days: 5))),
    Workout(name: 'Upper Body Strength', createdOn: DateTime.now().subtract(const Duration(days: 2))),
    Workout(name: 'Full Body Circuit', createdOn: DateTime.now().subtract(const Duration(days: 4))),
    Workout(name: 'Core Blast', createdOn: DateTime.now().subtract(const Duration(days: 3))),
  ];
}
