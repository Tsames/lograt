import 'package:flutter_test/flutter_test.dart';
import 'package:lograt/util/extensions/date_thresholds.dart';

void main() {
  test('beginningOfTheWeek returns Monday', () {
    final thursday = DateTime(2024, 1, 4); // Thursday
    final monday = thursday.beginningOfTheWeek;
    expect(monday, DateTime(2024, 1, 1, 0, 0, 0));
    expect(monday.weekday, DateTime.monday);
  });

  test('endOfTheWeek returns Sunday', () {
    final thursday = DateTime(2024, 1, 4); // Thursday
    final sunday = thursday.endOfTheWeek;
    expect(sunday, DateTime(2024, 1, 7, 23, 59, 59));
    expect(sunday.weekday, DateTime.sunday);
  });
}
