import 'package:loggy/loggy.dart';
import 'package:pi_mobile/data/app_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "theme_provider.g.dart";

@riverpod
class Theme extends _$Theme {
  static const _keyName = "theme";

  @override
  Future<AppTheme> build() async {
    final preferences = SharedPreferencesAsync();
    final themeString = await preferences.getString(_keyName);
    if (themeString == null) {
      return AppTheme.system;
    }

    return AppTheme.fromString(themeString) ?? AppTheme.system;
  }

  Future<void> updateTheme(AppTheme theme) async {
    final themeString = theme.name;
    logDebug("Updating theme to $themeString");

    final preferences = SharedPreferencesAsync();
    await preferences.setString(_keyName, themeString);

    ref.invalidateSelf();
  }
}