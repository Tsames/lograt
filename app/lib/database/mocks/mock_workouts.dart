import 'package:lograt/database/app_database.dart';
import 'package:lograt/database/mocks/mock_exercises.dart';
import 'package:lograt/database/mocks/mock_muscle_groups.dart';
import 'package:lograt/database/mocks/mock_workout_templates.dart';
import 'package:lograt/database/models/exercise.dart';
import 'package:lograt/database/models/exercise_instance.dart';
import 'package:lograt/database/models/set_type.dart';
import 'package:lograt/database/models/units.dart';
import 'package:lograt/database/models/workout.dart';
import 'package:lograt/services/uuid.dart';

ExerciseInstance _exercise(
  Exercise type,
  int order,
  List<SetRow> Function(String id) sets, {
  String? notes,
}) {
  final instanceId = uuid.v7();
  return ExerciseInstance(
    id: instanceId,
    exerciseType: type,
    order: order,
    sets: sets(instanceId),
    notes: notes,
  );
}

SetRow _set(
  String instanceId,
  int order, {
  int? reps,
  double? weight,
  Units? units,
  SetType? setType,
}) => SetRow(
  id: uuid.v7(),
  setOrder: order,
  exerciseInstanceId: instanceId,
  reps: reps,
  weight: weight,
  units: units,
  setType: setType,
  restTimeSeconds: null,
);

class MockWorkouts {
  static final List<Workout> sampleWorkouts = [
    // ------------- THIS WEEK (Recent - within 7 days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Push Day - Heavy',
      notes: 'Feeling strong, increased weight on bench',
      template: MockWorkoutTemplates.pushDayTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.shoulders,
        MockMuscleGroups.arms,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [
            _set(
              id,
              1,
              reps: 12,
              weight: 135.0,
              units: Units.pounds,
              setType: SetType.warmup,
            ),
            _set(
              id,
              2,
              reps: 10,
              weight: 185.0,
              units: Units.pounds,
              setType: SetType.working,
            ),
            _set(
              id,
              3,
              reps: 8,
              weight: 205.0,
              units: Units.pounds,
              setType: SetType.working,
            ),
          ],
          notes: 'New PR on third set!',
        ),
        _exercise(
          MockExercises.overheadPress,
          2,
          (id) => [
            _set(id, 1, reps: 10, weight: 95.0, units: Units.pounds),
            _set(id, 2, reps: 8, weight: 115.0, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Quick Cardio',
      exercises: [
        _exercise(
          MockExercises.kettlebellSwing,
          1,
          (id) => [
            _set(id, 1, reps: 20, weight: 24.0, units: Units.kilograms),
            _set(id, 2, reps: 20, weight: 24.0, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Pull Day',
      notes: 'Back and biceps focus',
      template: MockWorkoutTemplates.pullDayTemplate,
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.arms],
      exercises: [
        _exercise(
          MockExercises.pullups,
          1,
          (id) => [_set(id, 1, reps: 10), _set(id, 2, reps: 8)],
        ),
        _exercise(
          MockExercises.bicepCurl,
          2,
          (id) => [
            _set(id, 1, reps: 12, weight: 30.0, units: Units.pounds),
            _set(id, 2, reps: 10, weight: 35.0, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 5)),
      title: 'Leg Day',
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [
            _set(id, 1, reps: 5, weight: 100.0, units: Units.kilograms),
            _set(id, 2, reps: 5, weight: 120.0, units: Units.kilograms),
          ],
        ),
        _exercise(
          MockExercises.lunges,
          2,
          (id) => [
            _set(id, 1, reps: 10, weight: 40.0, units: Units.pounds),
            _set(id, 2, reps: 10, weight: 40.0, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 6)),
      title: 'Core Work',
      muscleGroups: [MockMuscleGroups.core],
      exercises: [
        _exercise(
          MockExercises.plank,
          1,
          (id) => [_set(id, 1, reps: 60), _set(id, 2, reps: 45)],
        ),
      ],
    ),

    // ------------- THIS MONTH (8-30 days ago) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 8)),
      title: 'Upper Body Pump',
      template: MockWorkoutTemplates.upperBodyTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.back,
        MockMuscleGroups.shoulders,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [
            _set(id, 1, reps: 15, weight: 135.0, units: Units.pounds),
            _set(id, 2, reps: 12, weight: 155.0, units: Units.pounds),
          ],
        ),
        _exercise(
          MockExercises.dumbbellRow,
          2,
          (id) => [
            _set(id, 1, reps: 12, weight: 55.0, units: Units.pounds),
            _set(id, 2, reps: 12, weight: 60.0, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 10)),
      title: 'Deadlift Focus',
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.deadlift,
          1,
          (id) => [
            _set(id, 1, reps: 5, weight: 225.0, units: Units.pounds),
            _set(id, 2, reps: 5, weight: 275.0, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 12)),
      title: 'Shoulders and Arms',
      muscleGroups: [MockMuscleGroups.shoulders, MockMuscleGroups.arms],
      exercises: [
        _exercise(
          MockExercises.overheadPress,
          1,
          (id) => [
            _set(id, 1, reps: 10, weight: 95.0, units: Units.pounds),
            _set(id, 2, reps: 8, weight: 105.0, units: Units.pounds),
          ],
        ),
        _exercise(
          MockExercises.lateralRaise,
          2,
          (id) => [
            _set(id, 1, reps: 15, weight: 20.0, units: Units.pounds),
            _set(id, 2, reps: 12, weight: 25.0, units: Units.pounds),
          ],
        ),
        _exercise(
          MockExercises.bicepCurl,
          3,
          (id) => [_set(id, 1, reps: 12, weight: 30.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 15)),
      title: 'Light Session',
      exercises: [
        _exercise(
          MockExercises.pushups,
          1,
          (id) => [_set(id, 1, reps: 25), _set(id, 2, reps: 20)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 18)),
      title: 'Push Day',
      template: MockWorkoutTemplates.pushDayTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.shoulders,
        MockMuscleGroups.arms,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 185.0, units: Units.pounds)],
        ),
        _exercise(
          MockExercises.overheadPress,
          2,
          (id) => [_set(id, 1, reps: 10, weight: 85.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 20)),
      title: 'Back Day',
      muscleGroups: [MockMuscleGroups.back],
      exercises: [
        _exercise(
          MockExercises.pullups,
          1,
          (id) => [_set(id, 1, reps: 12), _set(id, 2, reps: 10)],
        ),
        _exercise(
          MockExercises.dumbbellRow,
          2,
          (id) => [_set(id, 1, reps: 10, weight: 65.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 22)),
      title: 'Lower Body',
      template: MockWorkoutTemplates.legDayTemplate,
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 135.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 25)),
      title: 'Chest and Triceps',
      muscleGroups: [MockMuscleGroups.chest, MockMuscleGroups.arms],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [
            _set(id, 1, reps: 10, weight: 175.0, units: Units.pounds),
            _set(id, 2, reps: 8, weight: 185.0, units: Units.pounds),
          ],
        ),
        _exercise(
          MockExercises.tricepsExtension,
          2,
          (id) => [_set(id, 1, reps: 12, weight: 45.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 28)),
      title: 'Full Body Circuit',
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.back,
        MockMuscleGroups.legs,
      ],
      exercises: [
        _exercise(MockExercises.pushups, 1, (id) => [_set(id, 1, reps: 20)]),
        _exercise(MockExercises.pullups, 2, (id) => [_set(id, 1, reps: 8)]),
        _exercise(
          MockExercises.squat,
          3,
          (id) => [_set(id, 1, reps: 15, weight: 95.0, units: Units.pounds)],
        ),
      ],
    ),

    // ------------- 1-3 MONTHS AGO (31-90 days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 35)),
      title: 'Pull Day',
      template: MockWorkoutTemplates.pullDayTemplate,
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.arms],
      exercises: [
        _exercise(MockExercises.pullups, 1, (id) => [_set(id, 1, reps: 12)]),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 38)),
      title: 'Legs',
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [_set(id, 1, reps: 5, weight: 135.0, units: Units.kilograms)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 42)),
      title: 'Upper Body Power',
      exercises: [
        _exercise(
          MockExercises.overheadPress,
          1,
          (id) => [_set(id, 1, reps: 8, weight: 95.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 45)),
      title: 'Full Body',
      muscleGroups: [
        MockMuscleGroups.back,
        MockMuscleGroups.legs,
        MockMuscleGroups.core,
      ],
      exercises: [
        _exercise(
          MockExercises.deadlift,
          1,
          (id) => [_set(id, 1, reps: 5, weight: 225.0, units: Units.pounds)],
        ),
        _exercise(MockExercises.plank, 2, (id) => [_set(id, 1, reps: 60)]),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 50)),
      title: 'Push Day',
      template: MockWorkoutTemplates.pushDayTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.shoulders,
        MockMuscleGroups.arms,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 165.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 55)),
      title: 'Back and Biceps',
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.arms],
      exercises: [
        _exercise(
          MockExercises.chinups,
          1,
          (id) => [_set(id, 1, reps: 10), _set(id, 2, reps: 8)],
        ),
        _exercise(
          MockExercises.bicepCurl,
          2,
          (id) => [_set(id, 1, reps: 12, weight: 30.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 60)),
      title: 'Leg Day Heavy',
      template: MockWorkoutTemplates.legDayTemplate,
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [
            _set(id, 1, reps: 5, weight: 140.0, units: Units.kilograms),
            _set(id, 2, reps: 3, weight: 150.0, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 65)),
      title: 'Chest Focus',
      muscleGroups: [MockMuscleGroups.chest],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [
            _set(id, 1, reps: 8, weight: 185.0, units: Units.pounds),
            _set(id, 2, reps: 6, weight: 195.0, units: Units.pounds),
          ],
        ),
        _exercise(
          MockExercises.cableFly,
          2,
          (id) => [_set(id, 1, reps: 12, weight: 40.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 70)),
      title: 'Quick Workout',
      exercises: [
        _exercise(MockExercises.pushups, 1, (id) => [_set(id, 1, reps: 30)]),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 75)),
      title: 'Shoulders',
      muscleGroups: [MockMuscleGroups.shoulders],
      exercises: [
        _exercise(
          MockExercises.overheadPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 85.0, units: Units.pounds)],
        ),
        _exercise(
          MockExercises.facePull,
          2,
          (id) => [_set(id, 1, reps: 15, weight: 50.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 80)),
      title: 'Lower Body Strength',
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [_set(id, 1, reps: 8, weight: 115.0, units: Units.kilograms)],
        ),
        _exercise(
          MockExercises.legCurl,
          2,
          (id) => [_set(id, 1, reps: 12, weight: 80.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 85)),
      title: 'Pull Day',
      template: MockWorkoutTemplates.pullDayTemplate,
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.arms],
      exercises: [
        _exercise(MockExercises.pullups, 1, (id) => [_set(id, 1, reps: 10)]),
        _exercise(
          MockExercises.dumbbellRow,
          2,
          (id) => [_set(id, 1, reps: 10, weight: 60.0, units: Units.pounds)],
        ),
      ],
    ),

    // ------------- 3+ MONTHS AGO (91+ days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 95)),
      title: 'Deadlift Day',
      muscleGroups: [MockMuscleGroups.back, MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.deadlift,
          1,
          (id) => [_set(id, 1, reps: 5, weight: 250.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 100)),
      title: 'Chest Day',
      muscleGroups: [MockMuscleGroups.chest],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 135.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 110)),
      title: 'Upper Body',
      template: MockWorkoutTemplates.upperBodyTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.back,
        MockMuscleGroups.shoulders,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 155.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 120)),
      title: 'Arms',
      muscleGroups: [MockMuscleGroups.arms],
      exercises: [
        _exercise(
          MockExercises.bicepCurl,
          1,
          (id) => [_set(id, 1, reps: 12, weight: 25.0, units: Units.pounds)],
        ),
        _exercise(
          MockExercises.tricepsExtension,
          2,
          (id) => [_set(id, 1, reps: 12, weight: 35.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 130)),
      title: 'Leg Focus',
      muscleGroups: [MockMuscleGroups.legs],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [
            _set(id, 1, reps: 10, weight: 100.0, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 140)),
      title: 'Back Workout',
      muscleGroups: [MockMuscleGroups.back],
      exercises: [
        _exercise(MockExercises.pullups, 1, (id) => [_set(id, 1, reps: 8)]),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 150)),
      title: 'Push Session',
      template: MockWorkoutTemplates.pushDayTemplate,
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.shoulders,
        MockMuscleGroups.arms,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 145.0, units: Units.pounds)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 160)),
      title: 'Full Body Basics',
      muscleGroups: [
        MockMuscleGroups.chest,
        MockMuscleGroups.back,
        MockMuscleGroups.legs,
      ],
      exercises: [
        _exercise(
          MockExercises.benchPress,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 135.0, units: Units.pounds)],
        ),
        _exercise(
          MockExercises.squat,
          2,
          (id) => [_set(id, 1, reps: 10, weight: 95.0, units: Units.kilograms)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 180)),
      title: 'Old Workout',
      exercises: [
        _exercise(MockExercises.pushups, 1, (id) => [_set(id, 1, reps: 20)]),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 200)),
      title: 'Ancient Session',
      muscleGroups: [MockMuscleGroups.legs, MockMuscleGroups.core],
      exercises: [
        _exercise(
          MockExercises.squat,
          1,
          (id) => [_set(id, 1, reps: 10, weight: 80.0, units: Units.kilograms)],
        ),
      ],
    ),
  ];
}
