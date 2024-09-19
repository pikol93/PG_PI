import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/routes.dart';

class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _onLogOffPressed(context, ref),
            child: const Text("Log off"),
          ),
        ],
      ),
    );
  }

  void _onLogOffPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logOff();

    if (context.mounted) {
      const RootRoute().go(context);
    }
  }
}
