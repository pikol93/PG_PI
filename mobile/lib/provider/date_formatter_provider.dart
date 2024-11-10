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
    appLocale: currentLocale,
  );
}

class DateFormatter {
  final AppLocale appLocale;
  final DateFormat formatFullName;

  DateFormatter({
    required this.appLocale,
  }) : formatFullName = DateFormat.yMMMMEEEEd(
          appLocale.flutterLocale.languageCode,
        );

  String toFullName(DateTime dateTime) => formatFullName.format(dateTime);
}
