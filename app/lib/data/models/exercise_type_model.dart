import 'package:lograt/data/entities/exercise_type.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseTypeModel {
  final String id;
  final String name;
  final String? description;

  const ExerciseTypeModel({
    required this.id,
    required this.name,
    this.description,
  });

  ExerciseTypeModel.forTest({required String name, String? description})
    : this(id: uuidV7(), name: name, description: description);

  ExerciseTypeModel.fromEntity(ExerciseType entity)
    : this(id: entity.id, name: entity.name, description: entity.description);

  ExerciseType toEntity() {
    return ExerciseType(id: id, name: name, description: description);
  }

  static ExerciseTypeModel? fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    if (id == null || id is! String) return null;
    final name = map['name'];
    if (name == null || name is! String) return null;
    final description = map['description'];
    if (description is! String && description != null) return null;
    return ExerciseTypeModel(id: id, name: name, description: description);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }

  ExerciseTypeModel copyWith({String? id, String? name, String? description}) {
    return ExerciseTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseTypeModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseTypeModel(id: $id, name: $name, description: $description)';
}
