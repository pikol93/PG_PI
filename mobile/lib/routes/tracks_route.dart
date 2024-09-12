import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/app_navigation_drawer.dart';

class TracksRoute extends StatelessWidget {
  const TracksRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Tracks"),
      ),
      body: const Center(
        child: Column(
          children: [
            Text("tracks route"),
          ],
        ),
      ),
    );
  }
}
