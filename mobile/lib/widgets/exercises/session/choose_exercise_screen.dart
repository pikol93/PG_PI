import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/data/strength_exercise.dart';
import 'package:pi_mobile/widgets/exercises/session/pending_exercise_screen.dart';
import 'package:pi_mobile/widgets/common/activity_tile.dart';
import 'package:pi_mobile/widgets/common/app_navigation_drawer.dart';

class ChooseExerciseScreen extends StatelessWidget {
  const ChooseExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<StrengthExercise> exercises = getAllExercises();

    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Ćwiczenia"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: exercises
              .map((exercise) => ActivityTile(
                  headline: exercise.name,
                  imagePath: exercise.imageLink,
                  screen: PendingExerciseScreen(exercise)))
              .toList(),
        ),
      ),
    );
  }
}

List<StrengthExercise> getAllExercises() {
  return const [
    StrengthExercise(name: "Wyciskanie na klatkę", imageLink: "assets/benchpress.png"),
    StrengthExercise(name: 'Przysiad z tyłu', imageLink: "assets/backsquad.png"),
    StrengthExercise(name: 'Uginanie bicepsów', imageLink: "assets/biceps_curls.png"),
    StrengthExercise(name: 'Podciąganie', imageLink: "assets/pullups.png"),
  ];
}
