import '../../domain/entities/exercise_type.dart';

/// Data model for exercise_types table
/// This handles the SQLite representation and conversion to/from domain entities
class ExerciseTypeModel {
  final int? id;
  final String name;
  final String? description;

  const ExerciseTypeModel({this.id, required this.name, this.description});

  factory ExerciseTypeModel.fromEntity(ExerciseType entity) {
    return ExerciseTypeModel(id: entity.id, name: entity.name, description: entity.description);
  }

  factory ExerciseTypeModel.fromMap(Map<String, dynamic> map) {
    return ExerciseTypeModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  ExerciseType toEntity() {
    return ExerciseType(id: id, name: name, description: description);
  }

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'name': name, 'description': description};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExerciseTypeModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ExerciseTypeModel{ id: ${id ?? 'null'}, name: $name }';
}
