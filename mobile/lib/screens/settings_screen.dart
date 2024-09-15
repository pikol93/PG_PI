import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/app_navigation_drawer.dart';
import 'package:pi_mobile/provider/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

  void _onLogOffPressed(WidgetRef ref) {
    ref.read(authProvider.notifier).logOff();
  }
}
