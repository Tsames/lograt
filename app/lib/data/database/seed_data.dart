import '../../domain/entities/workout.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_type.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/units.dart';
import '../../domain/entities/set_type.dart';

class SeedData {
  static final List<Workout> sampleWorkouts = [
    // Recent workout with multiple exercises and varying set types
    Workout(
      'Push Day - Heavy',
      DateTime.now().subtract(const Duration(days: 1)),
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

    // Bodyweight workout - all zero weight
    Workout(
      'Calisthenics Session',
      DateTime.now().subtract(const Duration(days: 3)),
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

    // Workout with kilograms
    Workout('Leg Day', DateTime.now().subtract(const Duration(days: 5)), [
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

    // Single exercise workout
    Workout(
      'Deadlift Focus',
      DateTime.now().subtract(const Duration(days: 7)),
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

    // Empty workout - just logged but no exercises yet
    Workout(
      'Unfinished Session',
      DateTime.now().subtract(const Duration(days: 10)),
      [],
    ),

    // Workout with same exercise type multiple times (supersets)
    Workout('Arm Superset', DateTime.now().subtract(const Duration(days: 12)), [
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
    ]),

    // Old workout outside the recent window
    Workout(
      'Ancient History',
      DateTime.now().subtract(const Duration(days: 100)),
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

    // Workout with very short rest times
    Workout('HIT Circuit', DateTime.now().subtract(const Duration(days: 15)), [
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
    ]),
  ];
}
