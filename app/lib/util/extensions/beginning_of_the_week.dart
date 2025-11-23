extension DateThresholds on DateTime {
  DateTime get beginningOfTheWeek {
    final currentWeekday = weekday;
    final daysToSubtract = currentWeekday - 1;

    return DateTime(year, month, day).subtract(Duration(days: daysToSubtract));
  }

  DateTime get beginningOfTheMonth {
    return DateTime(year, month, 1);
  }

  DateTime get beginningOfThreeMonthsAgo {
    int targetMonth = month - 3;
    int targetYear = year;

    if (targetMonth <= 0) {
      targetMonth += 12;
      targetYear -= 1;
    }

    return DateTime(targetYear, targetMonth, 1);
  }
}
