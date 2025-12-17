extension DateThresholds on DateTime {
  DateTime get beginningOfTheWeek {
    return DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0,
    ).subtract(Duration(days: weekday - 1));
  }

  DateTime get endOfTheWeek {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
    ).add(Duration(days: 7 - weekday));
  }

  bool weekInNewMonth() {
    return beginningOfTheWeek.month < endOfTheWeek.month;
  }

  bool weekInNewYear() {
    return beginningOfTheWeek.year < endOfTheWeek.year;
  }

  DateTime get beginningOfTheLastMonth {
    return DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0,
    ).subtract(Duration(days: 30));
  }

  DateTime get beginningOfTheLastThreeMonths {
    return DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0,
    ).subtract(Duration(days: 90));
  }
}
