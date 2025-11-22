import 'package:lograt/util/uuidv7.dart';

class ExerciseType {
  final String id;
  final String name;
  final String? description;

  ExerciseType({String? id, required this.name, this.description})
    : id = id ?? uuidV7();

  ExerciseType copyWith({String? id, String? name, String? description}) {
    return ExerciseType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseType && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseType(id: $id, name: $name, description: $description)';
}
