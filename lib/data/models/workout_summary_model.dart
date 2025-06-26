import '../../domain/entities/workout_summary.dart';

/// Data model for workouts table
/// This handles the SQLite representation and conversion to/from domain entities
class WorkoutSummaryModel {
  final int? id;
  final String name;
  final DateTime createdOn;

  WorkoutSummaryModel({this.id, required this.name, required this.createdOn});

  factory WorkoutSummaryModel.fromEntity(WorkoutSummary workout) {
    return WorkoutSummaryModel(id: workout.id, name: workout.name, createdOn: workout.createdOn);
  }

  factory WorkoutSummaryModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSummaryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  WorkoutSummary toEntity() {
    return WorkoutSummary(id: id, name: name, createdOn: createdOn);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WorkoutSummaryModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WorkoutSummaryModel{ id: ${id ?? 'null'}, name: $name, createdOn: ${createdOn.toIso8601String()} }';
}
