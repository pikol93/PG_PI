import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/widgets/common/app_navigation_drawer.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: Text(context.t.exercises.title),
      ),
      body: const Center(
        child: Text("exercises route"),
      ),
    );
  }
}
