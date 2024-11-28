import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/app_theme.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/connection_settings_provider.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/development_mode_provider.dart";
import "package:pi_mobile/provider/exercise_model_service_provider.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:pi_mobile/provider/one_rep_max_service_provider.dart";
import "package:pi_mobile/provider/package_info_provider.dart";
import "package:pi_mobile/provider/stored_locale_provider.dart";
import "package:pi_mobile/provider/theme_provider.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:pi_mobile/service/stored_locale_service.dart";
import "package:pi_mobile/widgets/settings/development_setting.dart";
import "package:pi_mobile/widgets/settings/setting_button.dart";
import "package:pi_mobile/widgets/settings/setting_option.dart";
import "package:pi_mobile/widgets/settings/setting_text.dart";

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Column(
          children: [
            _ChangeLanguageSetting(),
            _ChangeThemeSetting(),
            _ChangeServerAddressSetting(),
            _GenerateHeartRateDataSetting(),
            _ClearHeartRateDataSetting(),
            _GenerateTracksSetting(),
            _ClearTracksSetting(),
            _GenerateOneRepMaxHistory(),
            _ClearOneRepMaxHistory(),
            _DisableDevelopmentModeSetting(),
            _AppInfoSetting(),
          ],
        ),
      );
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
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(storedLocaleProvider).when(
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
                  final locale = value?.locale;
                  if (locale == null) {
                    await StoredLocaleService.resetSavedLocale();
                  } else {
                    await StoredLocaleService.saveAndUpdateLocale(locale);
                  }

                  ref.read(storedLocaleProvider.notifier).forceRebuild();
                  ref.invalidate(currentLocaleProvider);
                },
              );
            },
            error: (obj, stack) =>
                Text(context.t.error.unexpectedErrorOccurred),
            loading: () => const CircularProgressIndicator(),
          );

  String _mapAppLocaleToSetting(BuildContext context, AppLocale locale) {
    final setting = switch (locale) {
      AppLocale.en => LocaleSetting.en,
      AppLocale.pl => LocaleSetting.pl,
    };

    return _mapToSetting(context, setting);
  }

  String _mapToSetting(BuildContext context, LocaleSetting setting) =>
      context.t.settings.language.language(context: setting);
}

class _ChangeThemeSetting extends ConsumerWidget {
  const _ChangeThemeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(themeProvider).when(
            data: (theme) => SettingOption<AppTheme>(
              icon: Icons.brush,
              title: context.t.settings.theme.title,
              alertTitle: context.t.settings.theme.alertTitle,
              possibleValues: AppTheme.values,
              currentValue: theme,
              itemToDisplayMapper: (variant) => _mapToDisplay(context, variant),
              onConfirmed: (variant) => _onConfirmed(ref, variant),
            ),
            error: (obj, stack) =>
                Text(context.t.error.unexpectedErrorOccurred),
            loading: () => const CircularProgressIndicator(),
          );

  String _mapToDisplay(BuildContext context, AppTheme theme) =>
      context.t.settings.theme.theme(context: theme.toLocalization());

  Future<void> _onConfirmed(WidgetRef ref, AppTheme? theme) async {
    final actualTheme = theme ?? AppTheme.system;
    await ref.read(themeProvider.notifier).updateTheme(actualTheme);
  }
}

class _ChangeServerAddressSetting extends ConsumerWidget {
  const _ChangeServerAddressSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(connectionSettingsProvider).when(
            data: (data) => SettingText(
              icon: Icons.computer,
              title: context.t.settings.serverAddress.title,
              alertTitle: context.t.settings.serverAddress.alertTitle,
              currentValue: data.serverAddress,
              onConfirmed: (value) => _onConfirmed(ref, value),
            ),
            error: (obj, stack) =>
                Text(context.t.error.unexpectedErrorOccurred),
            loading: () => const CircularProgressIndicator(),
          );

  void _onConfirmed(WidgetRef ref, String newValue) {
    ref.read(connectionSettingsProvider.notifier).updateServerAddress(newValue);
  }
}

class _GenerateHeartRateDataSetting extends ConsumerWidget {
  const _GenerateHeartRateDataSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.monitor_heart_outlined,
          title: context.t.settings.heartRate.generate.title,
          requiresConfirmation: true,
          alertTitle: context.t.settings.heartRate.generate.alertTitle,
          onConfirmed: () => _onGeneratePressed(context, ref),
        ),
      );

  Future<void> _onGeneratePressed(BuildContext context, WidgetRef ref) async {
    final manager = await ref.read(heartRateManagerProvider.future);
    await manager.generateHeartRateData();
  }
}

class _ClearHeartRateDataSetting extends ConsumerWidget {
  const _ClearHeartRateDataSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.monitor_heart_outlined,
          title: context.t.settings.heartRate.clear.title,
          requiresConfirmation: true,
          alertTitle: context.t.settings.heartRate.clear.alertTitle,
          onConfirmed: () => _onClearPressed(context, ref),
        ),
      );

  Future<void> _onClearPressed(BuildContext context, WidgetRef ref) async {
    final manager = await ref.read(heartRateManagerProvider.future);
    return manager.clear();
  }
}

class _GenerateTracksSetting extends ConsumerWidget {
  const _GenerateTracksSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.navigation,
          title: context.t.settings.tracks.generate.title,
          requiresConfirmation: true,
          alertTitle: context.t.settings.tracks.generate.alertTitle,
          onConfirmed: () => _onGeneratePressed(context, ref),
        ),
      );

  Future<void> _onGeneratePressed(BuildContext context, WidgetRef ref) async {
    final manager = await ref.read(tracksManagerProvider.future);
    await manager.generateTracks();
  }
}

class _ClearTracksSetting extends ConsumerWidget {
  const _ClearTracksSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.navigation,
          title: context.t.settings.tracks.clear.title,
          requiresConfirmation: true,
          alertTitle: context.t.settings.tracks.clear.alertTitle,
          onConfirmed: () => _onClearPressed(context, ref),
        ),
      );

  Future<void> _onClearPressed(BuildContext context, WidgetRef ref) async {
    final manager = await ref.read(tracksManagerProvider.future);
    return manager.clear();
  }
}

class _GenerateOneRepMaxHistory extends ConsumerWidget {
  const _GenerateOneRepMaxHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.fitness_center,
          title: "Generate 1RM history",
          requiresConfirmation: true,
          alertTitle: "Are you sure you want to generate 1RM history?",
          onConfirmed: () => _onGeneratePressed(context, ref),
        ),
      );

  Future<void> _onGeneratePressed(BuildContext context, WidgetRef ref) async {
    final exerciseModelService = await ref.read(
      exerciseModelServiceProvider.future,
    );
    await exerciseModelService.generateData().run();
  }
}

class _ClearOneRepMaxHistory extends ConsumerWidget {
  const _ClearOneRepMaxHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.fitness_center,
          title: "Clear 1RM history",
          requiresConfirmation: true,
          alertTitle: "Are you sure you want to clear 1RM history?",
          onConfirmed: () => _onClearPressed(context, ref),
        ),
      );

  Future<void> _onClearPressed(BuildContext context, WidgetRef ref) async {
    final service = await ref.read(
      oneRepMaxServiceProvider.future,
    );

    await service.clear().run();
  }
}

class _DisableDevelopmentModeSetting extends ConsumerWidget {
  const _DisableDevelopmentModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => DevelopmentSetting(
        child: SettingButton(
          icon: Icons.developer_board_off,
          title: context.t.settings.disableDevelopmentMode.title,
          requiresConfirmation: true,
          alertTitle: context.t.settings.disableDevelopmentMode.title,
          onConfirmed: () => _onLogOffPressed(context, ref),
        ),
      );

  void _onLogOffPressed(BuildContext context, WidgetRef ref) {
    ref.read(developmentModeProvider.notifier).setDevelopmentMode(false);
  }
}

class _AppInfoSetting extends ConsumerWidget with Logger {
  const _AppInfoSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingButton(
        icon: Icons.info,
        title: context.t.settings.appInfo.title,
        subtitle: ref.watch(packageInfoProvider).version,
        onConfirmed: () => _onAppInfoPressed(ref),
      );

  Future<void> _onAppInfoPressed(WidgetRef ref) async {
    unawaited(
      ref
          .read(developmentModeProvider.notifier)
          .decrementDevelopmentModeCounter(),
    );
  }
}
