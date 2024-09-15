import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/app_navigation_drawer.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/routes.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _onLogOffPressed(ref),
              child: const Text("Log off"),
            ),
          ],
        ),
      ),
    );
  }

  void _onLogOffPressed(WidgetRef ref) async {
    await ref.read(authProvider.notifier).logOff();

    if (mounted) {
      const RootRoute().go(context);
    }
  }
}
