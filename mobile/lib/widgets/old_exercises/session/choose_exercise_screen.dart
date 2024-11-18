import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/widgets/common/activity_tile.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/old_exercises/session/pending_exercise_screen.dart";

class ChooseExerciseScreen extends ConsumerStatefulWidget {
  final String workoutUuid;

  const ChooseExerciseScreen({required this.workoutUuid, super.key});

  @override
  ConsumerState<ChooseExerciseScreen> createState() => _ChooseExerciseScreen();
}

class _ChooseExerciseScreen extends ConsumerState<ChooseExerciseScreen> {
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
                  screen: PendingExerciseScreen(exercise, widget.workoutUuid),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

List<StrengthExercise> getAllExercises(BuildContext context) => const [
      StrengthExercise(
        name: "",
        imageLink: "assets/benchpress.png",
      ),
      StrengthExercise(
        name: "",
        imageLink: "assets/backsquad.png",
      ),
      StrengthExercise(
        name: "",
        imageLink: "assets/biceps_curls.png",
      ),
      StrengthExercise(
        name: "",
        imageLink: "assets/pullups.png",
      ),
    ];
