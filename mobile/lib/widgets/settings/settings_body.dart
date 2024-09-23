import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/data/app_theme.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/provider/connection_settings_provider.dart';
import 'package:pi_mobile/provider/stored_locale_provider.dart';
import 'package:pi_mobile/provider/theme_provider.dart';
import 'package:pi_mobile/routes.dart';
import 'package:pi_mobile/service/stored_locale_service.dart';
import 'package:pi_mobile/widgets/settings/setting_button.dart';
import 'package:pi_mobile/widgets/settings/setting_option.dart';
import 'package:pi_mobile/widgets/settings/setting_text.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _ChangeLanguageSetting(),
          _ChangeThemeSetting(),
          _ChangeServerAddressSetting(),
          _LogOffSetting(),
        ],
      ),
    );
  }
}

class _LocaleOption {
  final AppLocale? locale;
  final String display;

  _LocaleOption({
    required this.locale,
    required this.display,
  });
}

class _ChangeLanguageSetting extends ConsumerWidget with Logger {
  const _ChangeLanguageSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(storedLocaleProvider).when(
          data: (currentRawLocale) {
            final currentLocale = currentRawLocale == null
                ? null
                : AppLocaleUtils.parse(currentRawLocale);

            final defaultLocale = _LocaleOption(
              locale: null,
              display: _mapToSetting(context, LocaleSetting.none),
            );
            final options = AppLocale.values
                .map(
                  (locale) => _LocaleOption(
                    locale: locale,
                    display: _mapAppLocaleToSetting(context, locale),
                  ),
                )
                .toList(growable: true);
            options.insert(0, defaultLocale);

            final currentLocaleOption = options
                    .where((option) => option.locale == currentLocale)
                    .firstOrNull ??
                defaultLocale;

            return SettingOption<_LocaleOption>(
              icon: Icons.language,
              title: context.t.settings.language.title,
              alertTitle: context.t.settings.language.alertTitle,
              possibleValues: options,
              currentValue: currentLocaleOption,
              itemToDisplayMapper: (item) => item.display,
              onConfirmed: (value) async {
                var locale = value?.locale;
                if (locale == null) {
                  await StoredLocaleService.resetSavedLocale();
                } else {
                  await StoredLocaleService.saveAndUpdateLocale(locale);
                }

                ref.watch(storedLocaleProvider.notifier).forceRebuild();
              },
            );
          },
          error: (obj, stack) => const Text("An unexpected error occurred."),
          loading: () => const CircularProgressIndicator(),
        );
  }

  String _mapAppLocaleToSetting(BuildContext context, AppLocale locale) {
    final setting = switch (locale) {
      AppLocale.en => LocaleSetting.en,
      AppLocale.pl => LocaleSetting.pl,
    };

    return _mapToSetting(context, setting);
  }

  String _mapToSetting(BuildContext context, LocaleSetting setting) {
    return context.t.settings.language.language(context: setting);
  }
}

class _ChangeThemeSetting extends ConsumerWidget {
  const _ChangeThemeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(themeProvider).when(
          data: (theme) {
            return SettingOption<AppTheme>(
              icon: Icons.brush,
              title: context.t.settings.theme.title,
              alertTitle: context.t.settings.theme.alertTitle,
              possibleValues: AppTheme.values,
              currentValue: theme,
              itemToDisplayMapper: (variant) => _mapToDisplay(context, variant),
              onConfirmed: (variant) => _onConfirmed(ref, variant),
            );
          },
          error: (obj, stack) => const Text("An unexpected error occurred."),
          loading: () => const CircularProgressIndicator(),
        );
  }

  String _mapToDisplay(BuildContext context, AppTheme theme) {
    return context.t.settings.theme.theme(context: theme.toLocalization());
  }

  void _onConfirmed(WidgetRef ref, AppTheme? theme) async {
    final actualTheme = theme ?? AppTheme.system;
    await ref.read(themeProvider.notifier).updateTheme(actualTheme);
  }
}

class _ChangeServerAddressSetting extends ConsumerWidget {
  const _ChangeServerAddressSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(connectionSettingsProvider).when(
          data: (data) => SettingText(
            icon: Icons.computer,
            title: context.t.settings.serverAddress.title,
            alertTitle: context.t.settings.serverAddress.alertTitle,
            currentValue: data.serverAddress,
            onConfirmed: (value) => _onConfirmed(ref, value),
          ),
          error: (obj, stack) => const Text("An unexpected error occurred."),
          loading: () => const CircularProgressIndicator(),
        );
  }

  void _onConfirmed(WidgetRef ref, String newValue) {
    ref.read(connectionSettingsProvider.notifier).updateServerAddress(newValue);
  }
}

class _LogOffSetting extends ConsumerWidget {
  const _LogOffSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingButton(
      icon: Icons.logout,
      title: context.t.settings.logOff.title,
      requiresConfirmation: true,
      alertTitle: context.t.settings.logOff.alertTitle,
      onConfirmed: () => _onLogOffPressed(context, ref),
    );
  }

  void _onLogOffPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logOff();

    if (context.mounted) {
      const RootRoute().go(context);
    }
  }
}
