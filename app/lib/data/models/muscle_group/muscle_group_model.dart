import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/models/model.dart';
import 'package:lograt/util/uuidv7.dart';

class MuscleGroupModel implements Model {
  @override
  final String id;
  final String label;
  final String? description;

  static final tableName = 'muscle_groups';
  static final idFieldName = 'id';
  static final labelFieldName = 'label';
  static final descriptionFieldName = 'description';

  const MuscleGroupModel({
    required this.id,
    required this.label,
    this.description,
  });

  MuscleGroupModel.forTest({required String label, String? description})
    : this(id: uuidV7(), label: label, description: description);

  MuscleGroupModel.fromEntity(MuscleGroup muscleGroup)
    : this(
        id: muscleGroup.id,
        label: muscleGroup.label,
        description: muscleGroup.description,
      );

  MuscleGroup toEntity() {
    return MuscleGroup(id: id, label: label, description: description);
  }

  static MuscleGroupModel? fromMap(Map<String, dynamic> map) {
    final id = map[idFieldName];
    if (id == null || id is! String) return null;
    final label = map[labelFieldName];
    if (label == null || label is! String) return null;
    final description = map[descriptionFieldName];
    if (description != null && description is! String) return null;
    return MuscleGroupModel(id: id, label: label, description: description);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      idFieldName: id,
      labelFieldName: label,
      descriptionFieldName: description,
    };
  }

  MuscleGroupModel copyWith({String? id, String? label, String? description}) {
    return MuscleGroupModel(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroupModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroupModel(id: $id, label: $label, description: $description)';
}
