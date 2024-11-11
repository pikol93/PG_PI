import "package:table_calendar/table_calendar.dart";

extension DateTimeExtension on DateTime {
  bool isSameYearAndMonth(DateTime other) =>
      month == other.month && year == other.year;

  bool isDayBefore(DateTime other) =>
      !isSameDay(this, other) && isBefore(other);

  bool isDayAfter(DateTime other) => !isSameDay(this, other) && isAfter(other);
}
