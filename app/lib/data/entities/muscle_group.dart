import 'package:lograt/util/uuidv7.dart';

class MuscleGroup {
  final String id;
  final String label;
  final String? description;

  MuscleGroup({String? id, required this.label, this.description})
    : id = id ?? uuidV7();

  MuscleGroup copyWith({String? id, String? label, String? description}) {
    return MuscleGroup(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MuscleGroup && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MuscleGroup(id: $id, label: $label, description: $description)';
}
