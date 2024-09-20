import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/provider/connection_settings_provider.dart';
import 'package:pi_mobile/routes.dart';
import 'package:pi_mobile/widgets/settings/setting_button.dart';
import 'package:pi_mobile/widgets/settings/setting_text.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _ChangeServerAddressSetting(),
          _LogOffSetting(),
        ],
      ),
    );
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
