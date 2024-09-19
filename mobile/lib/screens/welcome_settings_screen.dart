import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/widgets/settings_body.dart';

class WelcomeSettingsScreen extends ConsumerWidget {
  const WelcomeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Settings"),
      ),
      body: const SettingsBody(),
    );
  }
}
