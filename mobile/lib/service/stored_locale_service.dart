import 'package:loggy/loggy.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: This class serves as a workaround for riverpod not playing nicely with slang. If possible,
// rework this class in the future.
class StoredLocaleService {
  static const _keyName = "stored_locale";

  static Future<void> initialize() async {
    await _readAndUpdateLocale();
  }

  static Future<void> saveAndUpdateLocale(AppLocale locale) async {
    final rawLocale = locale.name;
    logDebug("Updating locale to $rawLocale");

    final preferences = SharedPreferencesAsync();
    await preferences.setString(_keyName, locale.name);

    await _readAndUpdateLocale();
  }

  static Future<void> resetSavedLocale(AppLocale locale) async {
    final preferences = SharedPreferencesAsync();
    await preferences.remove(_keyName);
    await _readAndUpdateLocale();
  }

  static Future<void> _readAndUpdateLocale() async {
    final preferences = SharedPreferencesAsync();
    final rawLocale = await preferences.getString(_keyName);
    logDebug("Read locale: \"$rawLocale\"");

    if (rawLocale != null) {
      LocaleSettings.setLocaleRaw(rawLocale);
    } else {
      final findDeviceLocale = AppLocaleUtils.findDeviceLocale();
      LocaleSettings.setLocale(findDeviceLocale);
    }
  }
}
