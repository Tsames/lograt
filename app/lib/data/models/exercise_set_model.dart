import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/set_type.dart';
import '../../domain/entities/units.dart';

/// Data model for exercise_sets table
/// Handles SQLite representation and conversion to/from domain entities
class ExerciseSetModel {
  final int? databaseId;
  final int? exerciseId; // Foreign key to workout_exercises table
  final int order;
  final int reps;
  final double weight;
  final String units;
  final int? restTimeSeconds;
  final String setType;
  final String? notes;

  const ExerciseSetModel({
    this.databaseId,
    required this.exerciseId,
    required this.order,
    required this.reps,
    required this.weight,
    required this.units,
    this.restTimeSeconds,
    required this.setType,
    this.notes,
  });

  factory ExerciseSetModel.fromEntity({
    required ExerciseSet entity,
    required int exerciseId,
  }) {
    return ExerciseSetModel(
      databaseId: entity.databaseId,
      exerciseId: exerciseId,
      order: entity.order,
      reps: entity.reps,
      weight: entity.weight,
      units: entity.units.name,
      restTimeSeconds: entity.restTime?.inSeconds,
      setType: entity.setType.name,
      notes: entity.notes,
    );
  }

  factory ExerciseSetModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSetModel(
      databaseId: map['database_id'] as int?,
      exerciseId: map['exercise_id'] as int,
      order: map['set_order'] as int,
      reps: map['reps'] as int,
      weight: map['weight'] as double,
      units: map['units'] as String,
      restTimeSeconds: map['rest_time_seconds'] as int?,
      setType: map['set_type'] as String? ?? 'Working Set',
      notes: map['notes'] as String?,
    );
  }

  ExerciseSetModel copyWith({
    int? databaseId,
    int? exerciseId,
    int? order,
    int? reps,
    double? weight,
    String? units,
    int? restTimeSeconds,
    String? setType,
    String? notes,
  }) {
    return ExerciseSetModel(
      databaseId: databaseId ?? this.databaseId,
      exerciseId: exerciseId ?? this.exerciseId,
      order: order ?? this.order,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      units: units ?? this.units,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      setType: setType ?? this.setType,
      notes: notes ?? this.notes,
    );
  }

  ExerciseSet toEntity() {
    return ExerciseSet(
      databaseId: databaseId,
      order: order,
      reps: reps,
      weight: weight,
      units: Units.fromString(units),
      restTime: restTimeSeconds != null
          ? Duration(seconds: restTimeSeconds!)
          : null,
      setType: SetType.fromString(setType),
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'database_id': databaseId,
      'exercise_id': exerciseId,
      'set_order': order,
      'reps': reps,
      'weight': weight,
      'units': units,
      'rest_time_seconds': restTimeSeconds,
      'set_type': setType,
      'notes': notes,
    };
  }

  @override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetModel &&
          databaseId == other.databaseId &&
          exerciseId == other.exerciseId &&
          order == other.order &&
          reps == other.reps &&
          weight == other.weight &&
          units == other.units &&
          restTimeSeconds == other.restTimeSeconds &&
          setType == other.setType &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(
    databaseId,
    exerciseId,
    order,
    reps,
    weight,
    units,
    restTimeSeconds,
    setType,
    notes,
  );

  @override
  String toString() =>
      'ExerciseSetModel{ id: ${databaseId ?? 'null'}, workoutExerciseId: $exerciseId, set: $order }';
}
