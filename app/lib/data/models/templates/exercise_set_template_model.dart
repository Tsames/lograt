import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/util/uuidv7.dart';

const setTemplateTable = 'set_templates';

class ExerciseSetTemplateFields {
  static final List<String> values = [
    id,
    order,
    exerciseTemplateId,
    setType,
    units,
  ];

  static final String id = 'id';
  static final String order = 'set_template_order';
  static final String exerciseTemplateId = 'exercise_template_id';
  static final String setType = 'set_type';
  static final String units = 'units';
}

class ExerciseSetTemplateModel {
  final String id;
  final int order;
  final String exerciseTemplateId; // Foreign key to workout_exercises table
  final String? setType;
  final String? units;

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
    final id = map[ExerciseSetTemplateFields.id];
    if (id == null || id is! String) return null;
    final order = map[ExerciseSetTemplateFields.order];
    if (order == null || order is! int) return null;
    final exerciseTemplateId =
        map[ExerciseSetTemplateFields.exerciseTemplateId];
    if (exerciseTemplateId == null || exerciseTemplateId is! String) {
      return null;
    }
    final setType = map[ExerciseSetTemplateFields.setType];
    if (setType != null && setType is! String) return null;
    final units = map[ExerciseSetTemplateFields.units];
    if (units != null && units is! String) return null;
    return ExerciseSetTemplateModel(
      id: id,
      order: order,
      exerciseTemplateId: exerciseTemplateId,
      setType: setType,
      units: units,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ExerciseSetTemplateFields.id: id,
      ExerciseSetTemplateFields.order: order,
      ExerciseSetTemplateFields.exerciseTemplateId: exerciseTemplateId,
      ExerciseSetTemplateFields.setType: setType,
      ExerciseSetTemplateFields.units: units,
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
