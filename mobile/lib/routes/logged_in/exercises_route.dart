import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/app_navigation_drawer.dart';

class ExercisesRoute extends StatelessWidget {
  const ExercisesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Exercises"),
      ),
      body: const Center(
        child: Text("exercises route"),
      ),
    );
  }
}
