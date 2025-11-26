import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/util/uuidv7.dart';

class ExerciseSetTemplate {
  final String id;
  final int order;
  final SetType? setType;
  final Units? units;

  ExerciseSetTemplate({String? id, this.order = 0, this.setType, this.units})
    : id = id ?? uuidV7();

  ExerciseSetTemplate copyWith({
    String? id,
    int? order,
    SetType? setType,
    Units? units,
  }) {
    return ExerciseSetTemplate(
      id: id ?? this.id,
      order: order ?? this.order,
      setType: setType ?? this.setType,
      units: units ?? this.units,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSetTemplate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SetTemplate(id: $id, order: $order, setType: ${setType?.toString()}, units: ${units?.toString()})';
}
