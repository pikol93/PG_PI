import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/data/strength_exercise.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/widgets/common/activity_tile.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/exercises/session/pending_exercise_screen.dart";

class ChooseExerciseScreen extends StatelessWidget {
  const ChooseExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = getAllExercises(context);

    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: Text(context.t.exercises.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: exercises
              .map(
                (exercise) => ActivityTile(
                  headline: exercise.name,
                  imagePath: exercise.imageLink,
                  screen: PendingExerciseScreen(exercise),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

List<StrengthExercise> getAllExercises(BuildContext context) => [
      StrengthExercise(
        name: context.t.exercises.exercises.benchPress,
        imageLink: "assets/benchpress.png",
      ),
      StrengthExercise(
        name: context.t.exercises.exercises.backSquat,
        imageLink: "assets/backsquad.png",
      ),
      StrengthExercise(
        name: context.t.exercises.exercises.barbellCurls,
        imageLink: "assets/biceps_curls.png",
      ),
      StrengthExercise(
        name: context.t.exercises.exercises.pullUp,
        imageLink: "assets/pullups.png",
      ),
    ];
