import 'package:lograt/util/extensions/date_thresholds.dart';

extension DateFormats on DateTime {
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get weekdayName => _days[weekday - 1];

  String get monthName => _months[month - 1];

  String get timeOfDay => switch (hour) {
    >= 5 && < 12 => 'Morning',
    >= 12 && < 18 => 'Afternoon',
    >= 18 && < 23 => 'Evening',
    _ => 'Night',
  };

  String toDayOfTheMonth() {
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      suffix = switch (day % 10) {
        1 => 'st',
        2 => 'nd',
        3 => 'rd',
        _ => 'th',
      };
    }
    return '$day$suffix';
  }

  String toDayAndMonthFriendlyFormat() {
    return '$monthName ${toDayOfTheMonth()}';
  }

  String toLongFriendlyFormat() {
    return '$weekdayName, $monthName ${toDayOfTheMonth()}, $year';
  }

  String toWeekRangeFormat() {
    final start = beginningOfTheWeek;
    final end = endOfTheWeek;
    return 'Week of ${start.toDayAndMonthFriendlyFormat()} to ${weekInNewMonth() ? '${end.monthName} ' : ''}${end.toDayOfTheMonth()}${weekInNewYear() ? ' ${end.year}' : ''}';
  }
}
