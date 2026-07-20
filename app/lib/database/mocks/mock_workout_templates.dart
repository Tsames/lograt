import 'package:lograt/database/app_database.dart';
import 'package:lograt/database/mocks/mock_exercises.dart';
import 'package:lograt/database/models/set_type.dart';
import 'package:lograt/database/models/units.dart';
import 'package:lograt/database/models/workout_template.dart';
import 'package:lograt/util/uuid.dart';

WorkoutTemplateSetRow _templateSet(
  String templateId,
  int exerciseOrder,
  String? exerciseTypeId,
  int setOrder, {
  SetType? setType,
  Units? units,
}) => WorkoutTemplateSetRow(
  id: uuid.v7(),
  templateId: templateId,
  exerciseOrder: exerciseOrder,
  exerciseTypeId: exerciseTypeId,
  setOrder: setOrder,
  setType: setType,
  units: units,
);

class MockWorkoutTemplates {
  static final _pushDayId = uuid.v7();
  static final pushDayTemplate = WorkoutTemplate(
    id: _pushDayId,
    title: 'Push Day',
    description: 'Chest, shoulders, and triceps',
    sets: [
      // Bench Press
      _templateSet(_pushDayId, 1, MockExercises.benchPress.id, 1, setType: SetType.warmup, units: Units.pounds),
      _templateSet(_pushDayId, 1, MockExercises.benchPress.id, 2, setType: SetType.working, units: Units.pounds),
      _templateSet(_pushDayId, 1, MockExercises.benchPress.id, 3, setType: SetType.working, units: Units.pounds),
      // Overhead Press
      _templateSet(_pushDayId, 2, MockExercises.overheadPress.id, 1, units: Units.pounds),
      _templateSet(_pushDayId, 2, MockExercises.overheadPress.id, 2, units: Units.pounds),
      _templateSet(_pushDayId, 2, MockExercises.overheadPress.id, 3, units: Units.pounds),
      // Lateral Raise
      _templateSet(_pushDayId, 3, MockExercises.lateralRaise.id, 1, units: Units.pounds),
      _templateSet(_pushDayId, 3, MockExercises.lateralRaise.id, 2, units: Units.pounds),
      _templateSet(_pushDayId, 3, MockExercises.lateralRaise.id, 3, units: Units.pounds),
      // Triceps Extension
      _templateSet(_pushDayId, 4, MockExercises.tricepsExtension.id, 1, units: Units.pounds),
      _templateSet(_pushDayId, 4, MockExercises.tricepsExtension.id, 2, units: Units.pounds),
      _templateSet(_pushDayId, 4, MockExercises.tricepsExtension.id, 3, units: Units.pounds),
    ],
  );

  static final _pullDayId = uuid.v7();
  static final pullDayTemplate = WorkoutTemplate(
    id: _pullDayId,
    title: 'Pull Day',
    description: 'Back and biceps',
    sets: [
      // Pull-ups
      _templateSet(_pullDayId, 1, MockExercises.pullups.id, 1),
      _templateSet(_pullDayId, 1, MockExercises.pullups.id, 2),
      _templateSet(_pullDayId, 1, MockExercises.pullups.id, 3),
      // Dumbbell Row
      _templateSet(_pullDayId, 2, MockExercises.dumbbellRow.id, 1, units: Units.pounds),
      _templateSet(_pullDayId, 2, MockExercises.dumbbellRow.id, 2, units: Units.pounds),
      _templateSet(_pullDayId, 2, MockExercises.dumbbellRow.id, 3, units: Units.pounds),
      // Deadlift
      _templateSet(_pullDayId, 3, MockExercises.deadlift.id, 1, units: Units.pounds),
      _templateSet(_pullDayId, 3, MockExercises.deadlift.id, 2, units: Units.pounds),
      _templateSet(_pullDayId, 3, MockExercises.deadlift.id, 3, units: Units.pounds),
      // Bicep Curl
      _templateSet(_pullDayId, 4, MockExercises.bicepCurl.id, 1, units: Units.pounds),
      _templateSet(_pullDayId, 4, MockExercises.bicepCurl.id, 2, units: Units.pounds),
      _templateSet(_pullDayId, 4, MockExercises.bicepCurl.id, 3, units: Units.pounds),
    ],
  );

  static final _legDayId = uuid.v7();
  static final legDayTemplate = WorkoutTemplate(
    id: _legDayId,
    title: 'Leg Day',
    description: 'Lower body focus',
    sets: [
      // Squat
      _templateSet(_legDayId, 1, MockExercises.squat.id, 1, units: Units.kilograms),
      _templateSet(_legDayId, 1, MockExercises.squat.id, 2, units: Units.kilograms),
      _templateSet(_legDayId, 1, MockExercises.squat.id, 3, units: Units.kilograms),
      _templateSet(_legDayId, 1, MockExercises.squat.id, 4, units: Units.kilograms),
      // Leg Press
      _templateSet(_legDayId, 2, MockExercises.legPress.id, 1, units: Units.kilograms),
      _templateSet(_legDayId, 2, MockExercises.legPress.id, 2, units: Units.kilograms),
      _templateSet(_legDayId, 2, MockExercises.legPress.id, 3, units: Units.kilograms),
      // Deadlift
      _templateSet(_legDayId, 3, MockExercises.deadlift.id, 1, units: Units.kilograms),
      _templateSet(_legDayId, 3, MockExercises.deadlift.id, 2, units: Units.kilograms),
    ],
  );

  static final _upperBodyId = uuid.v7();
  static final upperBodyTemplate = WorkoutTemplate(
    id: _upperBodyId,
    title: 'Upper Body',
    description: 'Combined upper body workout',
    sets: [
      // Bench Press
      _templateSet(_upperBodyId, 1, MockExercises.benchPress.id, 1, units: Units.pounds),
      _templateSet(_upperBodyId, 1, MockExercises.benchPress.id, 2, units: Units.pounds),
      _templateSet(_upperBodyId, 1, MockExercises.benchPress.id, 3, units: Units.pounds),
      // Dumbbell Row
      _templateSet(_upperBodyId, 2, MockExercises.dumbbellRow.id, 1, units: Units.pounds),
      _templateSet(_upperBodyId, 2, MockExercises.dumbbellRow.id, 2, units: Units.pounds),
      _templateSet(_upperBodyId, 2, MockExercises.dumbbellRow.id, 3, units: Units.pounds),
    ],
  );
}
