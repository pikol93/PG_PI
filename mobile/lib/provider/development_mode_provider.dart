import "dart:async";

import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "development_mode_provider.g.dart";

@Riverpod(keepAlive: true)
class DevelopmentMode extends _$DevelopmentMode with Logger {
  static const _keyName = "dev_mode";

  bool isDevelopmentMode = false;

  @override
  bool build() {
    logger.debug("Setting development mode to $isDevelopmentMode");
    return isDevelopmentMode;
  }

  void init() {
    unawaited(_readDevelopmentModeFromStorage());
  }

  Future<void> setDevelopmentMode(bool value) =>
      _writeDevelopmentModeToStorage(value);

  void _setAndInvalidate(bool value) {
    isDevelopmentMode = value;
    ref.invalidateSelf();
  }

  Future<void> _readDevelopmentModeFromStorage() async {
    final preferences = SharedPreferencesAsync();
    final developmentMode = await preferences.getBool(_keyName) ?? false;

    ref
        .read(developmentModeProvider.notifier)
        ._setAndInvalidate(developmentMode);
  }

  Future<void> _writeDevelopmentModeToStorage(bool value) async {
    final preferences = SharedPreferencesAsync();
    await preferences.setBool(_keyName, value);
    return _readDevelopmentModeFromStorage();
  }
}
