import 'package:lograt/database/app_database.dart';
import 'package:lograt/database/models/exercise.dart';
import 'package:lograt/util/uuid.dart';

class ExerciseInstance {
  final String id;
  final int order;
  final List<SetRow> sets;
  final Exercise? exerciseType;
  final String? notes;

  ExerciseInstance({String? id, int? order, List<SetRow>? sets, this.exerciseType, this.notes})
    : id = id ?? uuid.v7(),
      order = order ?? 0,
      sets = sets ?? const <SetRow>[];

  ExerciseInstance copyWith({
    String Function()? id,
    int Function()? order,
    List<SetRow> Function()? sets,
    Exercise? Function()? exerciseType,
    String? Function()? notes,
  }) {
    return ExerciseInstance(
      id: id != null ? id() : this.id,
      order: order != null ? order() : this.order,
      sets: sets != null ? sets() : this.sets,
      exerciseType: exerciseType != null ? exerciseType() : this.exerciseType,
      notes: notes != null ? notes() : this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseInstance && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseInstance(id: $id, order: $order, sets: $sets, exerciseType: ${exerciseType?.toString()}, notes: $notes)';
}
