import 'dart:convert';

import '../../domain/entities/exercise_type.dart';

class ExerciseTypeModel {
  final int? id; // Nullable because SQLite auto-generates this
  final String name;
  final String? description;

  const ExerciseTypeModel({this.id, required this.name, this.description});

  // Convert from domain entity to data model
  factory ExerciseTypeModel.fromEntity(ExerciseType entity) {
    return ExerciseTypeModel(id: entity.id, name: entity.name, description: entity.description);
  }

  // Convert from data model to domain entity
  ExerciseType toEntity() {
    return ExerciseType(id: id, name: name, description: description);
  }

  // Convert from SQLite Map to data model
  factory ExerciseTypeModel.fromMap(Map<String, dynamic> map) {
    return ExerciseTypeModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  // Convert from data model to SQLite Map
  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'name': name, 'description': description};
  }
}
