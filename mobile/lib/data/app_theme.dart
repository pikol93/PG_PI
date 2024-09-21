import 'package:flutter/material.dart';
import 'package:pi_mobile/i18n/strings.g.dart';

enum AppTheme {
  system,
  light,
  dark;

  static AppTheme? fromString(String value) {
    return AppTheme.values
        .where((variant) => variant.name == value)
        .firstOrNull;
  }

  ThemeMode toThemeMode() {
    return switch (this) {
      AppTheme.system => ThemeMode.system,
      AppTheme.light => ThemeMode.light,
      AppTheme.dark => ThemeMode.dark,
    };
  }

  ThemeLocalization toLocalization() {
    return switch (this) {
      AppTheme.system => ThemeLocalization.system,
      AppTheme.light => ThemeLocalization.light,
      AppTheme.dark => ThemeLocalization.dark,
    };
  }
}
