extension DateThresholds on DateTime {
  DateTime get beginningOfTheWeek {
    final currentWeekday = weekday;
    final daysToSubtract = currentWeekday - 1;

    return DateTime(year, month, day).subtract(Duration(days: daysToSubtract));
  }

  DateTime get inTheLastMonth {
    return DateTime(year, month, day).subtract(Duration(days: 30));
  }

  DateTime get inTheLastThreeMonths {
    return DateTime(year, month, day).subtract(Duration(days: 90));
  }
}
