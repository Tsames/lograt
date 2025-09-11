import 'package:lograt/domain/entities/set_type.dart';
import 'package:lograt/domain/entities/units.dart';

/// Represents a single set within an exercise
class ExerciseSet {
  final int? databaseId; // SQLite generated primary key
  final int order; // 1st set, 2nd set, etc. within this exercise
  final int reps;
  final double weight; // 0 for body weight exercises
  final Units units;
  final Duration?
  restTime; // Rest time before this set, this value will sometimes be null before the first set
  final SetType setType;
  final String? notes;

  const ExerciseSet({
    this.databaseId,
    required this.order,
    this.reps = 0,
    this.weight = 0,
    this.units = Units.pounds,
    this.restTime,
    this.setType = SetType.working,
    this.notes,
  });

  ExerciseSet copyWith({
    int? databaseId,
    int? order,
    int? reps,
    double? weight,
    Units? units,
    Duration? restTime,
    SetType? setType,
    String? notes,
  }) {
    return ExerciseSet(
      databaseId: databaseId ?? this.databaseId,
      order: order ?? this.order,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      units: units ?? this.units,
      restTime: restTime ?? this.restTime,
      setType: setType ?? this.setType,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSet &&
          order == other.order &&
          reps == other.reps &&
          weight == other.weight &&
          units == other.units &&
          restTime == other.restTime &&
          setType == other.setType &&
          notes == other.notes;

  @override
  int get hashCode =>
      Object.hash(order, reps, weight, units, restTime, setType, notes);

  @override
  String toString() =>
      'ExerciseSet{ id: ${databaseId ?? 'null'}, order: $order, weight: $weight, units: ${units.name}, reps: $reps }';
}
