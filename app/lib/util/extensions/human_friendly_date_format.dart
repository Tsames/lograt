extension HumanFriendlyDateFormat on DateTime {
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

  String toDayFriendlyFormat() {
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

  String toMonthFriendlyFormat() {
    return _months[month - 1];
  }

  String toDayAndMonthFriendlyFormat() {
    return '${_months[month - 1]} ${toDayFriendlyFormat()}';
  }

  String toLongFriendlyFormat() {
    return '${_days[weekday - 1]}, ${_months[month - 1]} ${toDayFriendlyFormat()}, $year';
  }
}
