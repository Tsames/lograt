import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseModel implements Model {
  @override
  final String id;
  final int order;
  final String workoutId; // Foreign key to workouts table
  final String? exerciseTypeId; // Foreign key to exercise_types table
  final String? notes;

  static final tableName = 'exercises';
  static final idFieldName = 'id';
  static final orderFieldName = 'exercise_order';
  static final workoutIdFieldName = 'workout_id';
  static final exerciseTypeIdFieldName = 'exercise_type_id';
  static final notesFieldName = 'notes';

  const ExerciseModel({
    required this.id,
    required this.order,
    required this.workoutId,
    this.exerciseTypeId,
    this.notes,
  });

  ExerciseModel.forTest({
    required String workoutId,
    int? order,
    String? exerciseTypeId,
    String? notes,
  }) : this(
         id: uuidV7(),
         order: order ?? 0,
         workoutId: workoutId,
         exerciseTypeId: exerciseTypeId,
         notes: notes,
       );

  ExerciseModel.fromEntity(Exercise entity, String workoutId)
    : this(
        id: entity.id,
        order: entity.order,
        workoutId: workoutId,
        exerciseTypeId: entity.exerciseType?.id,
        notes: entity.notes,
      );

  Exercise toEntity(
    ExerciseType? exerciseType, [
    List<ExerciseSet> sets = const [],
  ]) {
    return Exercise(
      id: id,
      order: order,
      sets: sets,
      exerciseType: exerciseType,
      notes: notes,
    );
  }

  static ExerciseModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final order = map[orderFieldName];
    if (order == null || order is! int) return null;
    final workoutId = map[workoutIdFieldName];
    if (workoutId == null || workoutId is! String) return null;
    final exerciseTypeId = map[exerciseTypeIdFieldName];
    if (exerciseTypeId != null && exerciseTypeId is! String) return null;
    final notes = map[notesFieldName];
    if (notes != null && notes is! String) return null;
    return ExerciseModel(
      id: id,
      order: order,
      workoutId: workoutId,
      exerciseTypeId: exerciseTypeId,
      notes: notes,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      orderFieldName: order,
      workoutIdFieldName: workoutId,
      exerciseTypeIdFieldName: exerciseTypeId,
      notesFieldName: notes,
    };
  }

  ExerciseModel copyWith({
    String? id,
    int? order,
    String? workoutId,
    String? exerciseTypeId,
    String? notes,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      order: order ?? this.order,
      workoutId: workoutId ?? this.workoutId,
      exerciseTypeId: exerciseTypeId ?? this.exerciseTypeId,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseModel(id: $id, order: $order, workoutId: $workoutId, exerciseTypeId: $exerciseTypeId, notes: $notes)';
}
