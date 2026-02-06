import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseSetTemplateModel implements Model {
  @override
  final String id;
  final int order;
  final String exerciseTemplateId; // Foreign key to workout_exercises table
  final String? setType;
  final String? units;

  static final tableName = 'set_templates';
  static final idFieldName = 'id';
  static final orderFieldName = 'set_template_order';
  static final exerciseTemplateIdFieldName = 'exercise_template_id';
  static final setTypeFieldName = 'set_type';
  static final unitsFieldName = 'units';

  ExerciseSetTemplateModel({
    required this.id,
    required this.order,
    required this.exerciseTemplateId,
    this.setType,
    this.units,
  });

  ExerciseSetTemplateModel.forTest({
    required String exerciseTemplateId,
    int? order,
    String? setType,
    String? units,
  }) : this(
         id: uuidV7(),
         order: order ?? 0,
         exerciseTemplateId: exerciseTemplateId,
         setType: setType,
         units: units,
       );

  ExerciseSetTemplateModel.fromEntity({
    required ExerciseSetTemplate entity,
    required String exerciseTemplateId,
  }) : this(
         id: entity.id,
         order: entity.order,
         exerciseTemplateId: exerciseTemplateId,
         setType: entity.setType?.name,
         units: entity.units?.name,
       );

  ExerciseSetTemplate toEntity() {
    return ExerciseSetTemplate(
      id: id,
      order: order,
      setType: setType != null ? SetType.fromString(setType!) : null,
      units: units != null ? Units.fromString(units!) : null,
    );
  }

  static ExerciseSetTemplateModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final order = map[orderFieldName];
    if (order == null || order is! int) return null;
    final exerciseTemplateId = map[exerciseTemplateIdFieldName];
    if (exerciseTemplateId == null || exerciseTemplateId is! String) {
      return null;
    }
    final setType = map[setTypeFieldName];
    if (setType != null && setType is! String) return null;
    final units = map[unitsFieldName];
    if (units != null && units is! String) return null;
    return ExerciseSetTemplateModel(
      id: id,
      order: order,
      exerciseTemplateId: exerciseTemplateId,
      setType: setType,
      units: units,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      orderFieldName: order,
      exerciseTemplateIdFieldName: exerciseTemplateId,
      setTypeFieldName: setType,
      unitsFieldName: units,
    };
  }

  ExerciseSetTemplateModel copyWith({
    String? id,
    int? order,
    String? exerciseTemplateId,
    String? setType,
    String? units,
  }) {
    return ExerciseSetTemplateModel(
      id: id ?? this.id,
      order: order ?? this.order,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      setType: setType ?? this.setType,
      units: units ?? this.units,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSetTemplateModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseSetTemplateModel(id: $id, order: $order, exerciseId: $exerciseTemplateId, setType: ${setType?.toString()}, units: $units)';
}
