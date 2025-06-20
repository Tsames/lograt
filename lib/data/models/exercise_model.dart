import 'package:lograt/domain/entities/exercise_set.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_type.dart';

/// Data model for workout_exercises table
/// This handles the SQLite representation and conversion to/from domain entities
class ExerciseModel {
  final int? id;
  final int workoutId; // Foreign key to workouts table
  final int? exerciseTypeId; // Foreign key to exercise_types table
  final int order;
  final String? notes;

  const ExerciseModel({
    this.id,
    required this.workoutId,
    required this.exerciseTypeId,
    required this.order,
    this.notes,
  });

  factory ExerciseModel.fromEntity({required Exercise entity, required int workoutId}) {
    return ExerciseModel(
      id: entity.id,
      workoutId: workoutId,
      exerciseTypeId: entity.exerciseType.id,
      order: entity.order,
      notes: entity.notes,
    );
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] as int?,
      workoutId: map['workout_id'] as int,
      exerciseTypeId: map['exercise_type_id'] as int,
      order: map['order'] as int,
    );
  }

  Exercise toEntity({required ExerciseType exerciseType, List<ExerciseSet> sets = const []}) {
    return Exercise(id: id, exerciseType: exerciseType, order: order, sets: sets, notes: notes);
  }

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'workout_id': workoutId, 'exercise_type_id': exerciseTypeId, 'order': order};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExerciseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseModel{ id: ${id ?? 'null'}, workoutId: $workoutId, exerciseTypeId: $exerciseTypeId, order: $order }';
}
