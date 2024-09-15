import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/widgets/app_navigation_drawer.dart';
import 'package:pi_mobile/provider/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Home"),
      ),
      body: Center(
        child: switch (ref.watch(authProvider)) {
          AsyncData(:final value) => () {
              if (value == null) {
                return const Text("Invalid state. Could not read auth data.");
              } else {
                return Text("Hello ${value.username}");
              }
            }(),
          AsyncError() => const Text("Error while loading state."),
          _ => const CircularProgressIndicator(),
        },
      ),
    );
  }
}
