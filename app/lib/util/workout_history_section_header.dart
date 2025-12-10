import 'package:lograt/data/entities/workouts/workout.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';
import 'package:lograt/util/extensions/human_friendly_date_format.dart';

sealed class WorkoutHistorySectionHeader {
  final String title;

  WorkoutHistorySectionHeader(this.title);
}

class ThisWeekWorkoutHistorySectionHeader extends WorkoutHistorySectionHeader {
  ThisWeekWorkoutHistorySectionHeader() : super('This Week');

  static bool inRange(Workout workout, DateTime now) {
    return workout.date.isAfter(now.beginningOfTheWeek);
  }
}

class InTheLastMonthWorkoutHistorySectionHeader
    extends WorkoutHistorySectionHeader {
  InTheLastMonthWorkoutHistorySectionHeader() : super('In the Last Month');

  static bool inRange(Workout workout, DateTime now) {
    return workout.date.isBefore(now.beginningOfTheWeek) &&
        workout.date.isAfter(now.beginningOfTheLastMonth);
  }
}

class InTheLastThreeMonthsWorkoutHistorySectionHeader
    extends WorkoutHistorySectionHeader {
  InTheLastThreeMonthsWorkoutHistorySectionHeader()
    : super('In the Last Three Months');

  static bool inRange(Workout workout, DateTime now) {
    return workout.date.isBefore(now.beginningOfTheLastMonth) &&
        workout.date.isAfter(now.beginningOfTheLastThreeMonths);
  }
}

class WeekWorkoutHistorySectionHeader extends WorkoutHistorySectionHeader {
  WeekWorkoutHistorySectionHeader(DateTime workoutDate)
    : super(
        'Week of ${workoutDate.beginningOfTheWeek.toDayAndMonthFriendlyFormatDay()} to ${workoutDate.endOfTheWeek.toDayFriendlyFormat()}',
      );
}
