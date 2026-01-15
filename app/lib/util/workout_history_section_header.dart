import 'package:lograt/util/extensions/date_thresholds.dart';

enum WorkoutHistorySectionHeader {
  thisWeek('This Week'),
  lastMonth('In the Last Month'),
  lastThreeMonths('In the Last Three Months'),
  ancientHistory('Ancient History');

  final String title;

  static WorkoutHistorySectionHeader getSection(DateTime date) {
    final now = DateTime.now();
    if (date.isAfter(now.beginningOfTheWeek)) {
      return WorkoutHistorySectionHeader.thisWeek;
    } else if (date.isAfter(now.beginningOfTheLastMonth)) {
      return WorkoutHistorySectionHeader.lastMonth;
    } else if (date.isAfter(now.beginningOfTheLastThreeMonths)) {
      return WorkoutHistorySectionHeader.lastThreeMonths;
    } else {
      return WorkoutHistorySectionHeader.ancientHistory;
    }
  }

  const WorkoutHistorySectionHeader(this.title);
}
