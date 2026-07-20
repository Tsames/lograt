import 'package:lograt/database/app_database.dart';
import 'package:lograt/database/models/exercise_instance.dart';
import 'package:lograt/database/models/workout.dart';
import 'package:lograt/util/uuid.dart';

class WorkoutTemplate {
  final String id;
  final List<WorkoutTemplateSetRow> sets;
  final String? title;
  final String? description;

  WorkoutTemplate({String? id, List<WorkoutTemplateSetRow>? sets, this.title, this.description})
    : id = id ?? uuid.v7(),
      sets = sets ?? const <WorkoutTemplateSetRow>[];

  WorkoutTemplate copyWith({
    String Function()? id,
    List<WorkoutTemplateSetRow> Function()? sets,
    String? Function()? title,
    String? Function()? description,
  }) {
    return WorkoutTemplate(
      id: id != null ? id() : this.id,
      sets: sets != null ? sets() : this.sets,
      title: title != null ? title() : this.title,
      description: description != null ? description() : this.description,
    );
  }

  /// Creates a blank workout from this template, grouping set slots by
  /// [exerciseOrder] to reconstruct the exercise structure. The caller is
  /// responsible for resolving [WorkoutTemplateSetRow.exerciseTypeId] values
  /// to full [Exercise] objects after creation.
  Workout createFromTemplate() {
    final exerciseGroups = <int, List<WorkoutTemplateSetRow>>{};
    for (final set in sets) {
      exerciseGroups.putIfAbsent(set.exerciseOrder, () => []).add(set);
    }

    final exercises = exerciseGroups.entries.map((entry) {
      final instanceId = uuid.v7();
      final templateSets = entry.value..sort((a, b) => a.setOrder.compareTo(b.setOrder));
      return ExerciseInstance(
        id: instanceId,
        order: entry.key,
        sets: templateSets
            .map(
              (s) => SetRow(
                id: uuid.v7(),
                setOrder: s.setOrder,
                exerciseInstanceId: instanceId,
                setType: s.setType,
                weight: null,
                units: s.units,
                reps: null,
                restTimeSeconds: null,
              ),
            )
            .toList(),
      );
    }).toList()..sort((a, b) => a.order.compareTo(b.order));

    return Workout(exercises: exercises, title: title);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutTemplate && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WorkoutTemplate(id: $id, sets: $sets, title: $title, description: $description)';
}
