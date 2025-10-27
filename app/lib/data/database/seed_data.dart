import 'package:lograt/util/beginning_of_the_week.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/exercise_type.dart';
import '../../domain/entities/set_type.dart';
import '../../domain/entities/units.dart';
import '../../domain/entities/workout.dart';

class SeedData {
  static final beginningOfTheWeek = DateTime.now().beginningOfTheWeek;

  static final List<Workout> sampleWorkouts = [
    // ------------- THIS WEEK -------------
    Workout(
      'Push Day - Heavy',
      beginningOfTheWeek.add(const Duration(days: 1)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 12,
              weight: 135,
              units: Units.pounds,
              setType: SetType.warmup,
            ),
            const ExerciseSet(
              order: 2,
              reps: 10,
              weight: 185,
              units: Units.pounds,
              setType: SetType.working,
              restTime: Duration(minutes: 2),
            ),
            const ExerciseSet(
              order: 3,
              reps: 8,
              weight: 205,
              units: Units.pounds,
              setType: SetType.working,
              restTime: Duration(minutes: 2, seconds: 30),
            ),
            const ExerciseSet(
              order: 4,
              reps: 12,
              weight: 135,
              units: Units.pounds,
              setType: SetType.dropSet,
              restTime: Duration(minutes: 2),
              notes: 'Drop set to failure',
            ),
          ],
          notes: 'Felt strong today',
        ),
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Overhead Press'),
          order: 2,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 95,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 8,
              weight: 115,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 3,
              reps: 6,
              weight: 125,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Calisthenics Session',
      beginningOfTheWeek.add(const Duration(days: 3)),
      [
        Exercise(
          exerciseType: const ExerciseType(
            id: null,
            name: 'Pull-ups',
            description: 'Bodyweight upper body exercise',
          ),
          order: 1,
          sets: [
            const ExerciseSet(order: 1, reps: 10, weight: 0),
            const ExerciseSet(order: 2, reps: 8, weight: 0),
            const ExerciseSet(
              order: 3,
              reps: 6,
              weight: 0,
              setType: SetType.failure,
            ),
          ],
        ),
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Push-ups'),
          order: 2,
          sets: [
            const ExerciseSet(order: 1, reps: 25, weight: 0),
            const ExerciseSet(order: 2, reps: 20, weight: 0),
            const ExerciseSet(order: 3, reps: 15, weight: 0),
          ],
        ),
      ],
    ),

    Workout('Leg Day', beginningOfTheWeek.add(const Duration(days: 5)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Squat'),
        order: 1,
        sets: [
          const ExerciseSet(
            order: 1,
            reps: 5,
            weight: 100,
            units: Units.kilograms,
          ),
          const ExerciseSet(
            order: 2,
            reps: 5,
            weight: 120,
            units: Units.kilograms,
          ),
          const ExerciseSet(
            order: 3,
            reps: 5,
            weight: 140,
            units: Units.kilograms,
          ),
          const ExerciseSet(
            order: 4,
            reps: 3,
            weight: 150,
            units: Units.kilograms,
          ),
        ],
      ),
    ]),

    Workout(
      'Back and Biceps',
      beginningOfTheWeek.add(const Duration(days: 6)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Deadlift'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 8,
              weight: 185,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 8,
              weight: 225,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    // ------------- EARLIER THIS MONTH - 5 workouts -------------
    Workout(
      'Deadlift Focus',
      beginningOfTheWeek.subtract(const Duration(days: 10)),
      [
        Exercise(
          exerciseType: const ExerciseType(
            id: null,
            name: 'Deadlift',
            description: 'Compound posterior chain movement',
          ),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 5,
              weight: 225,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 5,
              weight: 275,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 3,
              reps: 3,
              weight: 315,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 4,
              reps: 1,
              weight: 365,
              units: Units.pounds,
              notes: 'New PR!',
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Upper Body',
      beginningOfTheWeek.subtract(const Duration(days: 12)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 175,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 8,
              weight: 185,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Arm Superset',
      beginningOfTheWeek.subtract(const Duration(days: 15)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bicep Curl'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 12,
              weight: 30,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 10,
              weight: 35,
              units: Units.pounds,
            ),
          ],
          notes: 'Superset with triceps',
        ),
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Triceps Extension'),
          order: 2,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 12,
              weight: 40,
              units: Units.pounds,
            ),
            const ExerciseSet(
              order: 2,
              reps: 10,
              weight: 45,
              units: Units.pounds,
            ),
          ],
        ),
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bicep Curl'),
          order: 3,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 15,
              weight: 25,
              units: Units.pounds,
              setType: SetType.dropSet,
            ),
          ],
          notes: 'Final burnout set',
        ),
      ],
    ),

    Workout(
      'HIT Circuit',
      beginningOfTheWeek.subtract(const Duration(days: 18)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Kettlebell Swing'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 20,
              weight: 24,
              units: Units.kilograms,
              restTime: Duration(seconds: 30),
            ),
            const ExerciseSet(
              order: 2,
              reps: 20,
              weight: 24,
              units: Units.kilograms,
              restTime: Duration(seconds: 30),
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Lower Body',
      beginningOfTheWeek.subtract(const Duration(days: 22)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Squat'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 135,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    // ------------- LAST MONTH -------------
    Workout('Push Day', beginningOfTheWeek.subtract(const Duration(days: 32)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
        order: 1,
        sets: [
          const ExerciseSet(
            order: 1,
            reps: 10,
            weight: 185,
            units: Units.pounds,
          ),
        ],
      ),
    ]),

    Workout('Pull Day', beginningOfTheWeek.subtract(const Duration(days: 35)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Pull-ups'),
        order: 1,
        sets: [
          const ExerciseSet(order: 1, reps: 12, weight: 0),
          const ExerciseSet(order: 2, reps: 10, weight: 0),
        ],
      ),
    ]),

    Workout('Legs', beginningOfTheWeek.subtract(const Duration(days: 38)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Squat'),
        order: 1,
        sets: [
          const ExerciseSet(
            order: 1,
            reps: 5,
            weight: 135,
            units: Units.kilograms,
          ),
        ],
      ),
    ]),

    Workout(
      'Upper Body',
      beginningOfTheWeek.subtract(const Duration(days: 42)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Overhead Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 8,
              weight: 95,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Full Body',
      beginningOfTheWeek.subtract(const Duration(days: 45)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Deadlift'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 5,
              weight: 225,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Cardio and Core',
      beginningOfTheWeek.subtract(const Duration(days: 48)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Plank'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 60,
              weight: 0,
              notes: '60 seconds',
            ),
          ],
        ),
      ],
    ),

    Workout('Arms', beginningOfTheWeek.subtract(const Duration(days: 51)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Bicep Curl'),
        order: 1,
        sets: [
          const ExerciseSet(
            order: 1,
            reps: 12,
            weight: 30,
            units: Units.pounds,
          ),
        ],
      ),
    ]),

    Workout(
      'Chest and Triceps',
      beginningOfTheWeek.subtract(const Duration(days: 54)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 175,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout('Back Day', beginningOfTheWeek.subtract(const Duration(days: 58)), [
      Exercise(
        exerciseType: const ExerciseType(id: null, name: 'Pull-ups'),
        order: 1,
        sets: [const ExerciseSet(order: 1, reps: 8, weight: 0)],
      ),
    ]),

    // ------------- MONTHS 2-3 AGO -------------
    Workout(
      'Heavy Squat Day',
      beginningOfTheWeek.subtract(const Duration(days: 65)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Squat'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 5,
              weight: 140,
              units: Units.kilograms,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Bench Press Focus',
      beginningOfTheWeek.subtract(const Duration(days: 68)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 8,
              weight: 185,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Deadlift Day',
      beginningOfTheWeek.subtract(const Duration(days: 72)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Deadlift'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 5,
              weight: 275,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Upper Body Power',
      beginningOfTheWeek.subtract(const Duration(days: 75)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Overhead Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 85,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Leg Focus',
      beginningOfTheWeek.subtract(const Duration(days: 78)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Squat'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 8,
              weight: 115,
              units: Units.kilograms,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Push Workout',
      beginningOfTheWeek.subtract(const Duration(days: 82)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 165,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Pull Workout',
      beginningOfTheWeek.subtract(const Duration(days: 85)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Pull-ups'),
          order: 1,
          sets: [const ExerciseSet(order: 1, reps: 10, weight: 0)],
        ),
      ],
    ),

    Workout(
      'Lower Body Strength',
      beginningOfTheWeek.subtract(const Duration(days: 88)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Deadlift'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 5,
              weight: 250,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),

    Workout(
      'Ancient History',
      beginningOfTheWeek.subtract(const Duration(days: 92)),
      [
        Exercise(
          exerciseType: const ExerciseType(id: null, name: 'Bench Press'),
          order: 1,
          sets: [
            const ExerciseSet(
              order: 1,
              reps: 10,
              weight: 135,
              units: Units.pounds,
            ),
          ],
        ),
      ],
    ),
  ];
}
