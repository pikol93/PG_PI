import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/routes.dart';
import 'package:pi_mobile/widgets/settings/setting_button.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _LogOffButton(),
        ],
      ),
    );
  }
}

class _LogOffButton extends ConsumerWidget {
  const _LogOffButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingButton(
      icon: Icons.logout,
      title: "Log off",
      requiresConfirmation: true,
      alertTitle: "Are you sure you want to log off?",
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
