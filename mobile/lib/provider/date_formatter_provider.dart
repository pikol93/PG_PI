import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "date_formatter_provider.g.dart";

@riverpod
AppLocale currentLocale(Ref ref) => LocaleSettings.currentLocale;

@riverpod
DateFormatter dateFormatter(Ref ref) {
  final currentLocale = ref.watch(currentLocaleProvider);

  return DateFormatter(
    languageCode: currentLocale.flutterLocale.languageCode,
  );
}

class DateFormatter {
  final String languageCode;
  final DateFormat formatFullDate;
  final DateFormat formatFullTime;
  final DateFormat formatHourMinute;
  final DateFormat formatOnlyNumbersDate;

  DateFormatter({
    required this.languageCode,
  })  : formatFullDate = DateFormat.yMMMMEEEEd(languageCode),
        formatFullTime = DateFormat.jms(languageCode),
        formatHourMinute = DateFormat.jm(languageCode),
        formatOnlyNumbersDate = DateFormat.yMd(languageCode);

  String fullDate(DateTime dateTime) => formatFullDate.format(dateTime);

  String fullDateTime(DateTime dateTime) =>
      "${formatFullDate.format(dateTime)} ${formatFullTime.format(dateTime)}";

  String hourMinute(DateTime dateTime) => formatHourMinute.format(dateTime);

  String onlyNumbersDate(DateTime dateTime) =>
      formatOnlyNumbersDate.format(dateTime);
}
