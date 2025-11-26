import 'package:lograt/data/entities/exercise_set.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/util/uuidv7.dart';

const setsTable = 'sets';

class ExerciseSetFields {
  static final List<String> values = [
    id,
    order,
    exerciseId,
    setType,
    weight,
    units,
    reps,
    restTimeSeconds,
  ];

  static final String id = 'id';
  static final String order = 'set_order';
  static final String exerciseId = 'exercise_id';
  static final String setType = 'set_type';
  static final String weight = 'weight';
  static final String units = 'units';
  static final String reps = 'reps';
  static final String restTimeSeconds = 'rest_time_seconds';
}

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
    final id = map[ExerciseSetFields.id];
    if (id == null || id is! String) return null;
    final order = map[ExerciseSetFields.order];
    if (order == null || order is! int) return null;
    final exerciseId = map[ExerciseSetFields.exerciseId];
    if (exerciseId == null || exerciseId is! String) return null;
    final setType = map[ExerciseSetFields.setType];
    if (setType != null && setType is! String) return null;
    final weight = map[ExerciseSetFields.weight];
    if (weight != null && weight is! double) return null;
    final units = map[ExerciseSetFields.units];
    if (units != null && units is! String) return null;
    final reps = map[ExerciseSetFields.reps];
    if (reps != null && reps is! int) return null;
    final restTimeSeconds = map[ExerciseSetFields.restTimeSeconds];
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
      ExerciseSetFields.id: id,
      ExerciseSetFields.order: order,
      ExerciseSetFields.exerciseId: exerciseId,
      ExerciseSetFields.setType: setType,
      ExerciseSetFields.weight: weight,
      ExerciseSetFields.units: units,
      ExerciseSetFields.reps: reps,
      ExerciseSetFields.restTimeSeconds: restTimeSeconds,
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
