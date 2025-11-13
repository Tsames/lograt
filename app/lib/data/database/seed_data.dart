import '../../util/extensions/beginning_of_the_week.dart';
import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/exercise_type.dart';
import '../entities/set_type.dart';
import '../entities/units.dart';
import '../entities/workout.dart';

class SeedData {
  static final beginningOfTheWeek = DateTime.now().beginningOfTheWeek;

  static final List<Workout> sampleWorkouts = [
    // ------------- THIS WEEK -------------
    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 1)),
      title: 'Push Day - Heavy',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
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
          notes: 'Felt strong today',
        ),
        Exercise(
          exerciseType: ExerciseType(name: 'Overhead Press'),
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 95, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 115, units: Units.pounds),
            ExerciseSet(order: 3, reps: 6, weight: 125, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 3)),
      title: 'Calisthenics Session',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(
            name: 'Pull-ups',
            description: 'Bodyweight upper body exercise',
          ),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 0),
            ExerciseSet(order: 2, reps: 8, weight: 0),
            ExerciseSet(order: 3, reps: 6, weight: 0, setType: SetType.failure),
          ],
        ),
        Exercise(
          exerciseType: ExerciseType(name: 'Push-ups'),
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 25, weight: 0),
            ExerciseSet(order: 2, reps: 20, weight: 0),
            ExerciseSet(order: 3, reps: 15, weight: 0),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 5)),
      title: 'Leg Day',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Squat'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 100, units: Units.kilograms),
            ExerciseSet(order: 2, reps: 5, weight: 120, units: Units.kilograms),
            ExerciseSet(order: 3, reps: 5, weight: 140, units: Units.kilograms),
            ExerciseSet(order: 4, reps: 3, weight: 150, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.add(const Duration(days: 6)),
      title: 'Back and Biceps',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Deadlift'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 185, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 225, units: Units.pounds),
          ],
        ),
      ],
    ),

    // ------------- EARLIER THIS MONTH - 5 workouts -------------
    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 10)),
      title: 'Deadlift Focus',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(
            name: 'Deadlift',
            description: 'Compound posterior chain movement',
          ),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 225, units: Units.pounds),
            ExerciseSet(order: 2, reps: 5, weight: 275, units: Units.pounds),
            ExerciseSet(order: 3, reps: 3, weight: 315, units: Units.pounds),
            ExerciseSet(order: 4, reps: 1, weight: 365, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 12)),
      title: 'Upper Body',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 175, units: Units.pounds),
            ExerciseSet(order: 2, reps: 8, weight: 185, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 15)),
      title: 'Arm Superset',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bicep Curl'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 35, units: Units.pounds),
          ],
          notes: 'Superset with triceps',
        ),
        Exercise(
          exerciseType: ExerciseType(name: 'Triceps Extension'),
          order: 2,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 40, units: Units.pounds),
            ExerciseSet(order: 2, reps: 10, weight: 45, units: Units.pounds),
          ],
        ),
        Exercise(
          exerciseType: ExerciseType(name: 'Bicep Curl'),
          order: 3,
          sets: [
            ExerciseSet(
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
      date: beginningOfTheWeek.subtract(const Duration(days: 18)),
      title: 'HIT Circuit',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Kettlebell Swing'),
          order: 1,
          sets: [
            ExerciseSet(
              order: 1,
              reps: 20,
              weight: 24,
              units: Units.kilograms,
              restTime: const Duration(seconds: 30),
            ),
            ExerciseSet(
              order: 2,
              reps: 20,
              weight: 24,
              units: Units.kilograms,
              restTime: const Duration(seconds: 30),
            ),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 22)),
      title: 'Lower Body',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Squat'),
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
          exerciseType: ExerciseType(name: 'Bench Press'),
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
          exerciseType: ExerciseType(name: 'Pull-ups'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 0),
            ExerciseSet(order: 2, reps: 10, weight: 0),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 38)),
      title: 'Legs',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Squat'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 135, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 42)),
      title: 'Upper Body',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Overhead Press'),
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
          exerciseType: ExerciseType(name: 'Deadlift'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 225, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 48)),
      title: 'Cardio and Core',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Plank'),
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
          exerciseType: ExerciseType(name: 'Bicep Curl'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 12, weight: 30, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 54)),
      title: 'Chest and Triceps',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 175, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 58)),
      title: 'Back Day',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Pull-ups'),
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 8, weight: 0)],
        ),
      ],
    ),

    // ------------- MONTHS 2-3 AGO -------------
    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 65)),
      title: 'Heavy Squat Day',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Squat'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 140, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 68)),
      title: 'Bench Press Focus',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 185, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 72)),
      title: 'Deadlift Day',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Deadlift'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 275, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 75)),
      title: 'Upper Body Power',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Overhead Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 85, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 78)),
      title: 'Leg Focus',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Squat'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 8, weight: 115, units: Units.kilograms),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 82)),
      title: 'Push Workout',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 165, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 85)),
      title: 'Pull Workout',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Pull-ups'),
          order: 1,
          sets: [ExerciseSet(order: 1, reps: 10, weight: 0)],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 88)),
      title: 'Lower Body Strength',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Deadlift'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 5, weight: 250, units: Units.pounds),
          ],
        ),
      ],
    ),

    Workout(
      date: beginningOfTheWeek.subtract(const Duration(days: 92)),
      title: 'Ancient History',
      exercises: [
        Exercise(
          exerciseType: ExerciseType(name: 'Bench Press'),
          order: 1,
          sets: [
            ExerciseSet(order: 1, reps: 10, weight: 135, units: Units.pounds),
          ],
        ),
      ],
    ),
  ];
}
