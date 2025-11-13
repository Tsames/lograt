import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseSet {
  final String id; // UUIDv7 generated primary key
  final int order; // 1st set, 2nd set, etc. within this exercise
  final SetType? setType;
  final double? weight;
  final Units? units;
  final int? reps;
  final Duration? restTime;

  ExerciseSet({
    String? id,
    this.order = 0,
    this.reps,
    this.weight,
    this.units,
    this.restTime,
    this.setType,
    this.notes,
  }) : id = id ?? uuidV7();

  ExerciseSet copyWith({
    String? id,
    int? order,
    SetType? setType,
    double? weight,
    Units? units,
    int? reps,
    Duration? restTime,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      order: order ?? this.order,
      setType: setType ?? this.setType,
      weight: weight ?? this.weight,
      units: units ?? this.units,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseSet(id: $id, order: $order, setType: ${setType.toString()}, weight: $weight, units: ${units.toString()}, reps: $reps, restTime: ${restTime.toString()})';
}
