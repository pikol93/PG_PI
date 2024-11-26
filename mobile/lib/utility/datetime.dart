import "package:table_calendar/table_calendar.dart";

extension DateTimeExtension on DateTime {
  bool isSameYearAndMonth(DateTime other) =>
      month == other.month && year == other.year;

  bool isDayBefore(DateTime other) =>
      !isSameDay(this, other) && isBefore(other);

  bool isDayAfter(DateTime other) => !isSameDay(this, other) && isAfter(other);

  DateTime toMidnightSameDay() => DateTime(year, month, day);

  DateTime toMidnightNextDay() => DateTime(year, month, day + 1);

  DateTime clamp(DateTime min, DateTime max) {
    if (min.isAfter(this)) {
      return min;
    }
    if (max.isBefore(this)) {
      return max;
    }

    return this;
  }
}
