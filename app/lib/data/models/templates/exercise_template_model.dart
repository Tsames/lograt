import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseTemplateModel implements Model {
  @override
  final String id;
  final int order;
  final String workoutTemplateId; // Foreign key to workout_templates table
  final String? exerciseTypeId; // Foreign key to exercise_types table

  static final tableName = 'exercise_templates';
  static final idFieldName = 'id';
  static final orderFieldName = 'exercise_order';
  static final workoutTemplateIdFieldName = 'workout_id';
  static final exerciseTypeIdFieldName = 'exercise_type_id';

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
    List<ExerciseSetTemplate> setTemplates = const [],
  ]) {
    return ExerciseTemplate(
      id: id,
      order: order,
      setTemplates: setTemplates,
      exerciseType: exerciseType,
    );
  }

  static ExerciseTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final order = map[orderFieldName];
    if (order == null || order is! int) return null;
    final workoutTemplateId = map[workoutTemplateIdFieldName];
    if (workoutTemplateId == null || workoutTemplateId is! String) return null;
    final exerciseTypeId = map[exerciseTypeIdFieldName];
    if (exerciseTypeId != null && exerciseTypeId is! String) return null;
    return ExerciseTemplateModel(
      id: id,
      order: order,
      workoutTemplateId: workoutTemplateId,
      exerciseTypeId: exerciseTypeId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      orderFieldName: order,
      workoutTemplateIdFieldName: workoutTemplateId,
      exerciseTypeIdFieldName: exerciseTypeId,
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
