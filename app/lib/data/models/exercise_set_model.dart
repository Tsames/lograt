import '../../util/uuidv7.dart';
import '../entities/exercise_set.dart';
import '../entities/set_type.dart';
import '../entities/units.dart';

class ExerciseSetModel {
  final String id;
  final int order;
  final String exerciseId; // Foreign key to workout_exercises table
  final String? setType;
  final double? weight;
  final String? units;
  final int? reps;
  final int? restTimeSeconds;

  ExerciseSetModel({
    required this.id,
    required this.order,
    required this.exerciseId,
    this.setType,
    this.weight,
    this.units,
    this.reps,
    this.restTimeSeconds,
  });

  ExerciseSetModel.forTest({
    required String exerciseId,
    int? order,
    String? setType,
    double? weight,
    String? units,
    int? reps,
    int? restTimeSeconds,
  }) : this(
         id: uuidV7(),
         order: order ?? 0,
         exerciseId: exerciseId,
         setType: setType,
         weight: weight,
         units: units,
         reps: reps,
         restTimeSeconds: restTimeSeconds,
       );

  ExerciseSetModel.fromEntity({
    required ExerciseSet entity,
    required String exerciseId,
  }) : this(
         id: entity.id,
         order: entity.order,
         exerciseId: exerciseId,
         setType: entity.setType?.name,
         weight: entity.weight,
         units: entity.units?.name,
         reps: entity.reps,
         restTimeSeconds: entity.restTime?.inSeconds,
       );

  ExerciseSet toEntity() {
    return ExerciseSet(
      id: id,
      order: order,
      setType: setType != null ? SetType.fromString(setType!) : null,
      weight: weight,
      units: units != null ? Units.fromString(units!) : null,
      reps: reps,
      restTime: restTimeSeconds != null
          ? Duration(seconds: restTimeSeconds!)
          : null,
    );
  }

  static ExerciseSetModel? fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    if (id == null || id is! String) return null;
    final order = map['set_order'];
    if (order == null || order is! int) return null;
    final exerciseId = map['exercise_id'];
    if (exerciseId == null || exerciseId is! String) return null;
    final setType = map['set_type'];
    if (setType != null && setType is! String) return null;
    final weight = map['weight'];
    if (weight != null && weight is! double) return null;
    final units = map['units'];
    if (units != null && units is! String) return null;
    final reps = map['reps'];
    if (reps != null && reps is! int) return null;
    final restTimeSeconds = map['rest_time_seconds'];
    if (restTimeSeconds != null && restTimeSeconds is! int) return null;
    return ExerciseSetModel(
      id: id,
      order: order,
      exerciseId: exerciseId,
      setType: setType,
      weight: weight,
      units: units,
      reps: reps,
      restTimeSeconds: restTimeSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'set_order': order,
      'exercise_id': exerciseId,
      'set_type': setType,
      'weight': weight,
      'units': units,
      'reps': reps,
      'rest_time_seconds': restTimeSeconds,
    };
  }

  ExerciseSetModel copyWith({
    String? id,
    int? order,
    String? exerciseId,
    String? setType,
    double? weight,
    String? units,
    int? reps,
    int? restTimeSeconds,
  }) {
    return ExerciseSetModel(
      id: id ?? this.id,
      order: order ?? this.order,
      exerciseId: exerciseId ?? this.exerciseId,
      setType: setType ?? this.setType,
      weight: weight ?? this.weight,
      units: units ?? this.units,
      reps: reps ?? this.reps,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSetModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseSetModel(id: $id, order: $order, exerciseId: $exerciseId, setType: ${setType?.toString()}, weight: $weight, units: $units, reps: $reps, restTimeSeconds: $restTimeSeconds)';
}
