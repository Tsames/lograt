import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/util/uuidv7.dart';

const exerciseTemplatesTable = 'exercise_templates';

class ExerciseTemplateFields {
  static final List<String> values = [
    id,
    order,
    workoutTemplateId,
    exerciseTypeId,
  ];

  static final String id = 'id';
  static final String order = 'exercise_order';
  static final String workoutTemplateId = 'workout_id';
  static final String exerciseTypeId = 'exercise_type_id';
}

class ExerciseTemplateModel {
  final String id;
  final int order;
  final String workoutTemplateId; // Foreign key to workout_templates table
  final String? exerciseTypeId; // Foreign key to exercise_types table

  const ExerciseTemplateModel({
    required this.id,
    required this.order,
    required this.workoutTemplateId,
    this.exerciseTypeId,
  });

  ExerciseTemplateModel.forTest({
    required String workoutTemplateId,
    int? order,
    String? exerciseTypeId,
  }) : this(
         id: uuidV7(),
         order: order ?? 0,
         workoutTemplateId: workoutTemplateId,
         exerciseTypeId: exerciseTypeId,
       );

  ExerciseTemplateModel.fromEntity(
    ExerciseTemplate entity,
    String workoutTemplateId,
  ) : this(
        id: entity.id,
        order: entity.order,
        workoutTemplateId: workoutTemplateId,
        exerciseTypeId: entity.exerciseType?.id,
      );

  ExerciseTemplate toEntity(
    ExerciseType? exerciseType, [
    List<ExerciseSetTemplate> sets = const [],
  ]) {
    return ExerciseTemplate(
      id: id,
      order: order,
      sets: sets,
      exerciseType: exerciseType,
    );
  }

  static ExerciseTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[ExerciseTemplateFields.id];
    if (id == null || id is! String) return null;
    final order = map[ExerciseTemplateFields.order];
    if (order == null || order is! int) return null;
    final workoutTemplateId = map[ExerciseTemplateFields.workoutTemplateId];
    if (workoutTemplateId == null || workoutTemplateId is! String) return null;
    final exerciseTypeId = map[ExerciseTemplateFields.exerciseTypeId];
    if (exerciseTypeId != null && exerciseTypeId is! String) return null;
    return ExerciseTemplateModel(
      id: id,
      order: order,
      workoutTemplateId: workoutTemplateId,
      exerciseTypeId: exerciseTypeId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ExerciseTemplateFields.id: id,
      ExerciseTemplateFields.order: order,
      ExerciseTemplateFields.workoutTemplateId: workoutTemplateId,
      ExerciseTemplateFields.exerciseTypeId: exerciseTypeId,
    };
  }

  ExerciseTemplateModel copyWith({
    String? id,
    int? order,
    String? workoutTemplateId,
    String? exerciseTypeId,
  }) {
    return ExerciseTemplateModel(
      id: id ?? this.id,
      order: order ?? this.order,
      workoutTemplateId: workoutTemplateId ?? this.workoutTemplateId,
      exerciseTypeId: exerciseTypeId ?? this.exerciseTypeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseTemplateModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseTemplateModel(id: $id, order: $order, workoutTemplateId: $workoutTemplateId, exerciseTypeId: $exerciseTypeId)';
}
