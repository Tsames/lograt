import 'package:lograt/data/entities/muscle_group.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/templates/exercise_set_template.dart';
import 'package:lograt/data/entities/templates/exercise_template.dart';
import 'package:lograt/data/entities/templates/workout_template.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/data/entities/workouts/exercise.dart';
import 'package:lograt/data/entities/workouts/exercise_set.dart';
import 'package:lograt/data/entities/workouts/exercise_type.dart';
import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';

class SeedData {
  static final beginningOfTheWeek = DateTime.now().beginningOfTheWeek;

  // Define muscle groups
  static final chest = MuscleGroup(
    label: 'Chest',
    description: 'Pectoral muscles',
  );
  static final back = MuscleGroup(
    label: 'Back',
    description: 'Latissimus dorsi, traps, rhomboids',
  );
  static final shoulders = MuscleGroup(
    label: 'Shoulders',
    description: 'Deltoids',
  );
  static final arms = MuscleGroup(
    label: 'Arms',
    description: 'Biceps and triceps',
  );
  static final legs = MuscleGroup(
    label: 'Legs',
    description: 'Quadriceps, hamstrings, glutes',
  );
  static final core = MuscleGroup(
    label: 'Core',
    description: 'Abdominals and obliques',
  );

  // Define all exercise types once
  static final benchPress = ExerciseType(
    name: 'Bench Press',
    description: 'Barbell chest press on flat bench',
  );
  static final overheadPress = ExerciseType(
    name: 'Overhead Press',
    description: 'Standing barbell shoulder press',
  );
  static final pullups = ExerciseType(
    name: 'Pull-ups',
    description: 'Bodyweight upper body exercise',
  );
  static final pushups = ExerciseType(name: 'Push-ups');
  static final squat = ExerciseType(
    name: 'Squat',
    description: 'Barbell back squat',
  );
  static final deadlift = ExerciseType(
    name: 'Deadlift',
    description: 'Compound posterior chain movement',
  );
  static final bicepCurl = ExerciseType(name: 'Bicep Curl');
  static final tricepsExtension = ExerciseType(name: 'Triceps Extension');
  static final kettlebellSwing = ExerciseType(name: 'Kettlebell Swing');
  static final plank = ExerciseType(name: 'Plank');
  static final dumbbellRow = ExerciseType(name: 'Dumbbell Row');
  static final lateralRaise = ExerciseType(name: 'Lateral Raise');
  static final legPress = ExerciseType(name: 'Leg Press');
  static final lunges = ExerciseType(name: 'Lunges');
  static final chinups = ExerciseType(name: 'Chin-ups');
  static final cableFly = ExerciseType(name: 'Cable Fly');
  static final legCurl = ExerciseType(name: 'Leg Curl');
  static final calfRaise = ExerciseType(name: 'Calf Raise');
  static final facePull = ExerciseType(name: 'Face Pull');

  // Define workout templates
  static final pushDayTemplate = WorkoutTemplate(
    title: 'Push Day',
    description: 'Chest, shoulders, and triceps',
    muscleGroups: [chest, shoulders, arms],
    exerciseTemplates: [
      ExerciseTemplate(
        order: 1,
        exerciseType: benchPress,
        setTemplates: [
          ExerciseSetTemplate(
            order: 1,
            setType: SetType.warmup,
            units: Units.pounds,
          ),
          ExerciseSetTemplate(
            order: 2,
            setType: SetType.working,
            units: Units.pounds,
          ),
          ExerciseSetTemplate(
            order: 3,
            setType: SetType.working,
            units: Units.pounds,
          ),
        ],
      ),
      ExerciseTemplate(
        order: 2,
        exerciseType: overheadPress,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
      ExerciseTemplate(
        order: 3,
        exerciseType: lateralRaise,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
      ExerciseTemplate(
        order: 4,
        exerciseType: tricepsExtension,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
    ],
  );

  static final pullDayTemplate = WorkoutTemplate(
    title: 'Pull Day',
    description: 'Back and biceps',
    muscleGroups: [back, arms],
    exerciseTemplates: [
      ExerciseTemplate(
        order: 1,
        exerciseType: pullups,
        setTemplates: [
          ExerciseSetTemplate(order: 1),
          ExerciseSetTemplate(order: 2),
          ExerciseSetTemplate(order: 3),
        ],
      ),
      ExerciseTemplate(
        order: 2,
        exerciseType: dumbbellRow,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
      ExerciseTemplate(
        order: 3,
        exerciseType: deadlift,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
      ExerciseTemplate(
        order: 4,
        exerciseType: bicepCurl,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
    ],
  );

  static final legDayTemplate = WorkoutTemplate(
    title: 'Leg Day',
    description: 'Lower body focus',
    muscleGroups: [legs],
    exerciseTemplates: [
      ExerciseTemplate(
        order: 1,
        exerciseType: squat,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.kilograms),
          ExerciseSetTemplate(order: 2, units: Units.kilograms),
          ExerciseSetTemplate(order: 3, units: Units.kilograms),
          ExerciseSetTemplate(order: 4, units: Units.kilograms),
        ],
      ),
      ExerciseTemplate(
        order: 2,
        exerciseType: legPress,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.kilograms),
          ExerciseSetTemplate(order: 2, units: Units.kilograms),
          ExerciseSetTemplate(order: 3, units: Units.kilograms),
        ],
      ),
      ExerciseTemplate(
        order: 3,
        exerciseType: deadlift,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.kilograms),
          ExerciseSetTemplate(order: 2, units: Units.kilograms),
        ],
      ),
    ],
  );

  static final upperBodyTemplate = WorkoutTemplate(
    title: 'Upper Body',
    description: 'Combined upper body workout',
    muscleGroups: [chest, back, shoulders],
    exerciseTemplates: [
      ExerciseTemplate(
        order: 1,
        exerciseType: benchPress,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
      ExerciseTemplate(
        order: 2,
        exerciseType: dumbbellRow,
        setTemplates: [
          ExerciseSetTemplate(order: 1, units: Units.pounds),
          ExerciseSetTemplate(order: 2, units: Units.pounds),
          ExerciseSetTemplate(order: 3, units: Units.pounds),
        ],
      ),
    ],
  );

  static final List<Workout> sampleWorkouts = [
    // ------------- THIS WEEK (Recent - within 7 days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Push Day - Heavy',
      notes: 'Feeling strong, increased weight on bench',
      template: pushDayTemplate,
      muscleGroups: [chest, shoulders, arms],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(
              order: 1,
              reps: 12,
              weight: 135,
              units: Units.pounds,
              setType: SetType.warmup,
            ),
            ExerciseSet(
              order: 2,
              reps: 10,
              weight: 185,
              units: Units.pounds,
              setType: SetType.working,
            ),
            ExerciseSet(
              order: 3,
              reps: 8,
              weight: 205,
              units: Units.pounds,
              setType: SetType.working,
            ),
          ],
          notes: 'New PR on third set!',
        ),
        Exercise(
          exerciseType: overheadPress,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 95, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 115, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Quick Cardio',
      // No template, no muscle groups
      exercises: [
        Exercise(
          exerciseType: kettlebellSwing,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 20, weight: 24, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 20, weight: 24, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Pull Day',
      notes: 'Back and biceps focus',
      template: pullDayTemplate,
      muscleGroups: [back, arms],
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 0),
            ExerciseSet(order: 2, reps: 8, weight: 0),
          ],
        ),
        Exercise(
          exerciseType: bicepCurl,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 35, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 5)),
      title: 'Leg Day',
      muscleGroups: [legs],
      // Has muscle groups but no template
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 100, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 5, weight: 120, units: Units.kilograms),
          ],
        ),
        Exercise(
          exerciseType: lunges,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 40, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 40, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 6)),
      title: 'Core Work',
      muscleGroups: [core],
      exercises: [
        Exercise(
          exerciseType: plank,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 60, weight: 0),
            ExerciseSet(order: 2, reps: 45, weight: 0),
          ],
        ),
      ],
    ),

    // ------------- THIS MONTH (8-30 days ago) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 8)),
      title: 'Upper Body Pump',
      template: upperBodyTemplate,
      muscleGroups: [chest, back, shoulders],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 135, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 155, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: dumbbellRow,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 55, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 60, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 10)),
      title: 'Deadlift Focus',
      muscleGroups: [back, legs],
      exercises: [
        Exercise(
          exerciseType: deadlift,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 225, units: Units.pounds),
            ExerciseSet(order: 2, reps: 5, weight: 275, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 12)),
      title: 'Shoulders and Arms',
      // No template, multiple muscle groups
      muscleGroups: [shoulders, arms],
      exercises: [
        Exercise(
          exerciseType: overheadPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 95, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 105, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: lateralRaise,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 20, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 25, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: bicepCurl,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 15)),
      title: 'Light Session',
      // No template, no muscle groups
      exercises: [
        Exercise(
          exerciseType: pushups,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 25, weight: 0),
            ExerciseSet(order: 2, reps: 20, weight: 0),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 18)),
      title: 'Push Day',
      template: pushDayTemplate,
      muscleGroups: [chest, shoulders, arms],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 185, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: overheadPress,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 85, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 20)),
      title: 'Back Day',
      muscleGroups: [back],
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 0),
            ExerciseSet(order: 2, reps: 10, weight: 0),
          ],
        ),
        Exercise(
          exerciseType: dumbbellRow,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 65, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 22)),
      title: 'Lower Body',
      template: legDayTemplate,
      muscleGroups: [legs],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 135, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 25)),
      title: 'Chest and Triceps',
      muscleGroups: [chest, arms],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 175, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 185, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: tricepsExtension,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 45, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 28)),
      title: 'Full Body Circuit',
      // No template, multiple muscle groups
      muscleGroups: [chest, back, legs],
      exercises: [
        Exercise(
          exerciseType: pushups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 20, weight: 0)],
        ),
        Exercise(
          exerciseType: pullups,
          order: 2,
          sets: [ExerciseSet(order: 1, reps: 8, weight: 0)],
        ),
        Exercise(
          exerciseType: squat,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 95, units: Units.pounds),
          ],
        ),
      ],
    ),

    // ------------- 1-3 MONTHS AGO (31-90 days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 35)),
      title: 'Pull Day',
      template: pullDayTemplate,
      muscleGroups: [back, arms],
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 12, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 38)),
      title: 'Legs',
      muscleGroups: [legs],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 135, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 42)),
      title: 'Upper Body Power',
      // No template, no muscle groups
      exercises: [
        Exercise(
          exerciseType: overheadPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 95, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 45)),
      title: 'Full Body',
      muscleGroups: [back, legs, core],
      exercises: [
        Exercise(
          exerciseType: deadlift,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 225, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: plank,
          order: 2,
          sets: [ExerciseSet(order: 1, reps: 60, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 50)),
      title: 'Push Day',
      template: pushDayTemplate,
      muscleGroups: [chest, shoulders, arms],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 165, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 55)),
      title: 'Back and Biceps',
      muscleGroups: [back, arms],
      exercises: [
        Exercise(
          exerciseType: chinups,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 0),
            ExerciseSet(order: 2, reps: 8, weight: 0),
          ],
        ),
        Exercise(
          exerciseType: bicepCurl,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 60)),
      title: 'Leg Day Heavy',
      template: legDayTemplate,
      muscleGroups: [legs],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 140, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 3, weight: 150, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 65)),
      title: 'Chest Focus',
      // No template, single muscle group
      muscleGroups: [chest],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 185, units: Units.pounds),
            ExerciseSet(order: 2, reps: 6, weight: 195, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: cableFly,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 40, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 70)),
      title: 'Quick Workout',
      // No template, no muscle groups
      exercises: [
        Exercise(
          exerciseType: pushups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 30, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 75)),
      title: 'Shoulders',
      muscleGroups: [shoulders],
      exercises: [
        Exercise(
          exerciseType: overheadPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 85, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: facePull,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 50, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 80)),
      title: 'Lower Body Strength',
      muscleGroups: [legs],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 115, units: Units.kilograms),
          ],
        ),
        Exercise(
          exerciseType: legCurl,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 80, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 85)),
      title: 'Pull Day',
      template: pullDayTemplate,
      muscleGroups: [back, arms],
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 10, weight: 0)],
        ),
        Exercise(
          exerciseType: dumbbellRow,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 60, units: Units.pounds),
          ],
        ),
      ],
    ),

    // ------------- 3+ MONTHS AGO (91+ days) -------------
    Workout(
      date: DateTime.now().subtract(const Duration(days: 95)),
      title: 'Deadlift Day',
      muscleGroups: [back, legs],
      exercises: [
        Exercise(
          exerciseType: deadlift,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 250, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 100)),
      title: 'Chest Day',
      muscleGroups: [chest],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 135, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 110)),
      title: 'Upper Body',
      template: upperBodyTemplate,
      muscleGroups: [chest, back, shoulders],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 155, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 120)),
      title: 'Arms',
      muscleGroups: [arms],
      exercises: [
        Exercise(
          exerciseType: bicepCurl,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 25, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: tricepsExtension,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 35, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 130)),
      title: 'Leg Focus',
      // No template, single muscle group
      muscleGroups: [legs],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(
              order: 1,
              reps: 10,
              weight: 100,
              units: Units.kilograms,
            ),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 140)),
      title: 'Back Workout',
      muscleGroups: [back],
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 8, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 150)),
      title: 'Push Session',
      template: pushDayTemplate,
      muscleGroups: [chest, shoulders, arms],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 145, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 160)),
      title: 'Full Body Basics',
      // No template, multiple muscle groups
      muscleGroups: [chest, back, legs],
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 135, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: squat,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 95, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 180)),
      title: 'Old Workout',
      // No template, no muscle groups
      exercises: [
        Exercise(
          exerciseType: pushups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 20, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: DateTime.now().subtract(const Duration(days: 200)),
      title: 'Ancient Session',
      muscleGroups: [legs, core],
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 80, units: Units.kilograms),
          ],
        ),
      ],
    ),
  ];
}
