import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';

/// Data model for workouts table
/// This handles the SQLite representation and conversion to/from domain entities
class WorkoutModel {
  final int? id;
  final String name;
  final DateTime createdOn;

  WorkoutModel({this.id, required this.name, required this.createdOn});

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(id: workout.id, name: workout.name, createdOn: workout.createdOn);
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  Workout toEntity({List<Exercise> exercises = const []}) {
    return Workout(id: id, name: name, createdOn: createdOn, exercises: exercises);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WorkoutModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseTypeModel{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }';
}
