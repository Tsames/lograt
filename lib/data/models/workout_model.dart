import '../../domain/entities/workout.dart';

class WorkoutModel {
  final int? id;
  final String name;
  final DateTime createdOn;

  WorkoutModel({this.id, required this.name, required this.createdOn});

  // Convert from database map to model
  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  // Convert model to database map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  // Convert data model to domain entity
  Workout toDomain() {
    return Workout(id: id, name: name, createdOn: createdOn);
  }

  // Convert domain entity to data model
  factory WorkoutModel.fromDomain(Workout workout) {
    return WorkoutModel(id: workout.id, name: workout.name, createdOn: workout.createdOn);
  }
}
