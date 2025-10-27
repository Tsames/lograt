extension BeginningOfTheWeek on DateTime {
  DateTime get beginningOfTheWeek {
    final currentWeekday = weekday;
    final daysToSubtract = currentWeekday - 1;

    return DateTime(year, month, day).subtract(Duration(days: daysToSubtract));
  }
}
