import "package:intl/intl.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "date_formatter_provider.g.dart";

@riverpod
AppLocale currentLocale(CurrentLocaleRef ref) => LocaleSettings.currentLocale;

@riverpod
DateFormatter dateFormatter(DateFormatterRef ref) {
  final currentLocale = ref.watch(currentLocaleProvider);

  return DateFormatter(
    languageCode: currentLocale.flutterLocale.languageCode,
  );
}

class DateFormatter {
  final String languageCode;
  final DateFormat formatFullDate;
  final DateFormat formatFullTime;

  DateFormatter({
    required this.languageCode,
  })  : formatFullDate = DateFormat.yMMMMEEEEd(languageCode),
        formatFullTime = DateFormat.jms(languageCode);

  String fullDate(DateTime dateTime) => formatFullDate.format(dateTime);

  String fullDateTime(DateTime dateTime) =>
      "${formatFullDate.format(dateTime)} ${formatFullTime.format(dateTime)}";
}
