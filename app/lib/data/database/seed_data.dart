import 'package:lograt/data/entities/exercise.dart';
import 'package:lograt/data/entities/exercise_set.dart';
import 'package:lograt/data/entities/exercise_type.dart';
import 'package:lograt/data/entities/set_type.dart';
import 'package:lograt/data/entities/units.dart';
import 'package:lograt/data/entities/workout.dart';
import 'package:lograt/util/extensions/beginning_of_the_week.dart';

class SeedData {
  static final beginningOfTheWeek = DateTime.now().beginningOfTheWeek;

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

  static final List<Workout> sampleWorkouts = [
    // ------------- THIS WEEK -------------
    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 1)),
      title: 'Push Day - Heavy',
      notes: 'Feeling strong, increased weight on bench',
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
              restTime: const Duration(minutes: 2),
            ),
            ExerciseSet(
              order: 3,
              reps: 8,
              weight: 205,
              units: Units.pounds,
              setType: SetType.working,
              restTime: const Duration(minutes: 2, seconds: 30),
            ),
            ExerciseSet(
              order: 4,
              reps: 12,
              weight: 135,
              units: Units.pounds,
              setType: SetType.dropSet,
              restTime: const Duration(minutes: 2),
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
            ExerciseSet(order: 3, reps: 6, weight: 125, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: lateralRaise,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 20, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 25, units: Units.pounds),
            ExerciseSet(order: 3, reps: 10, weight: 25, units: Units.pounds),
          ],
          notes: 'Focus on slow negatives',
        ),
        Exercise(
          exerciseType: tricepsExtension,
          order: 4,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 40, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 50, units: Units.pounds),
            ExerciseSet(order: 3, reps: 8, weight: 50, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 3)),
      title: 'Pull Day',
      notes: 'Back and biceps focus',
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 0),
            ExerciseSet(order: 2, reps: 8, weight: 0),
            ExerciseSet(order: 3, reps: 6, weight: 0, setType: SetType.failure),
          ],
          notes: 'Almost got that 11th rep!',
        ),
        Exercise(
          exerciseType: dumbbellRow,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 60, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 70, units: Units.pounds),
            ExerciseSet(order: 3, reps: 8, weight: 75, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: deadlift,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 185, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 225, units: Units.pounds),
            ExerciseSet(order: 3, reps: 5, weight: 245, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: bicepCurl,
          order: 4,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 35, units: Units.pounds),
            ExerciseSet(order: 3, reps: 8, weight: 35, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 5)),
      title: 'Leg Day',
      notes: 'Hit new depth on squats',
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 100, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 5, weight: 120, units: Units.kilograms),
            ExerciseSet(order: 3, reps: 5, weight: 140, units: Units.kilograms),
            ExerciseSet(order: 4, reps: 3, weight: 150, units: Units.kilograms),
          ],
          notes: 'Depth was excellent today',
        ),
        Exercise(
          exerciseType: legPress,
          order: 2,
          sets: [
            ExerciseSet(
              order: 1,
              reps: 12,
              weight: 200,
              units: Units.kilograms,
            ),
            ExerciseSet(
              order: 2,
              reps: 10,
              weight: 240,
              units: Units.kilograms,
            ),
            ExerciseSet(order: 3, reps: 8, weight: 260, units: Units.kilograms),
          ],
        ),
        Exercise(
          exerciseType: deadlift,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 140, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 6, weight: 160, units: Units.kilograms),
          ],
          notes: 'Romanian deadlifts for hamstrings',
        ),
        Exercise(
          exerciseType: bicepCurl,
          order: 4,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 25, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 30, units: Units.pounds),
          ],
          notes: 'Extra arm work',
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 6)),
      title: 'Upper Body Pump',
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 15, weight: 135, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 155, units: Units.pounds),
            ExerciseSet(order: 3, reps: 10, weight: 165, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: dumbbellRow,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 55, units: Units.pounds),
            ExerciseSet(order: 2, reps: 12, weight: 60, units: Units.pounds),
            ExerciseSet(order: 3, reps: 10, weight: 65, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: overheadPress,
          order: 3,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 85, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 95, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: pushups,
          order: 4,
          sets: [
            ExerciseSet(order: 1, reps: 25, weight: 0),
            ExerciseSet(order: 2, reps: 20, weight: 0),
            ExerciseSet(
              order: 3,
              reps: 15,
              weight: 0,
              setType: SetType.failure,
            ),
          ],
        ),
      ],
    ),

    // ------------- EARLIER THIS MONTH -------------
    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 10)),
      title: 'Deadlift Focus',
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
      date: beginningOfTheWeek.subtract(const Duration(days: 12)),
      title: 'Upper Body',
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 175, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 15)),
      title: 'Arm Superset',
      exercises: [
        Exercise(
          exerciseType: bicepCurl,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 35, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: tricepsExtension,
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 40, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 18)),
      title: 'Quick Session',
      exercises: [
        Exercise(
          exerciseType: kettlebellSwing,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 20, weight: 24, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 22)),
      title: 'Lower Body',
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

    // ------------- LAST MONTH -------------
    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 32)),
      title: 'Push Day',
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 185, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 35)),
      title: 'Pull Day',
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 12, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 38)),
      title: 'Legs',
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
      date: beginningOfTheWeek.subtract(const Duration(days: 42)),
      title: 'Upper Body Power',
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
      date: beginningOfTheWeek.subtract(const Duration(days: 45)),
      title: 'Full Body',
      exercises: [
        Exercise(
          exerciseType: deadlift,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 225, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 48)),
      title: 'Core',
      exercises: [
        Exercise(
          exerciseType: plank,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 60, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 51)),
      title: 'Arms',
      exercises: [
        Exercise(
          exerciseType: bicepCurl,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 54)),
      title: 'Chest',
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 175, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 58)),
      title: 'Back',
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 8, weight: 0)],
        ),
      ],
    ),

    // ------------- MONTHS 2-3 AGO -------------
    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 65)),
      title: 'Squat Day',
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 140, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 68)),
      title: 'Bench',
      exercises: [
        Exercise(
          exerciseType: benchPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 185, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 72)),
      title: 'Deadlift',
      exercises: [
        Exercise(
          exerciseType: deadlift,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 275, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 75)),
      title: 'Shoulders',
      exercises: [
        Exercise(
          exerciseType: overheadPress,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 85, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 78)),
      title: 'Legs',
      exercises: [
        Exercise(
          exerciseType: squat,
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 115, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 82)),
      title: 'Push',
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
      date: beginningOfTheWeek.subtract(const Duration(days: 85)),
      title: 'Pull',
      exercises: [
        Exercise(
          exerciseType: pullups,
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 10, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 88)),
      title: 'Lower',
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
      date: beginningOfTheWeek.subtract(const Duration(days: 92)),
      title: 'Chest',
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
  ];
}
