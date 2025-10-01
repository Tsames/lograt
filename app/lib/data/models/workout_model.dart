import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';

/// Data model for workouts table
/// This handles the SQLite representation and conversion to/from domain entities
class WorkoutModel {
  final int? id;
  final String name;
  final DateTime createdOn;

  WorkoutModel(this.name, this.createdOn, {this.id});

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(id: workout.id, workout.name, workout.createdOn);
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] as int?,
      map['name'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  Workout toEntity([List<Exercise> exercises = const []]) {
    return Workout(id: id, name, createdOn, exercises);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  WorkoutModel copyWith({int? id, String? name, DateTime? createdOn, List<Exercise>? exercises}) {
    return WorkoutModel(id: id ?? this.id, name ?? this.name, createdOn ?? this.createdOn);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WorkoutModel{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }';
}
