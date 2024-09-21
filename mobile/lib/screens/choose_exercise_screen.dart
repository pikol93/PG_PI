import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/classes/strength_exercise.dart';
import 'package:pi_mobile/screens/pending_exercise_screen.dart';
import 'package:pi_mobile/widgets/app_navigation_drawer.dart';

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
              .map((exercise) => buildTile(context, exercise))
              .toList(),
        ),
      ),
    );
  }


  Widget buildTile(BuildContext context, StrengthExercise exercise) {
    return GestureDetector(
      onTap: () async {
        final pendingResult = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PendingExerciseScreen(exercise)),
        );
        Navigator.pop(context, pendingResult);
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                exercise.imageLink,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(exercise.name),
            ),
          ],
        ),
      ),
    );
  }
}
List<StrengthExercise> getAllExercises(){
  return [
    StrengthExercise("Wyciskanie na klatkę", "assets/benchpress.png"),
    StrengthExercise('Przysiad z tyłu',"assets/backsquad.png"),
    StrengthExercise('Uginanie bicepsów',"assets/biceps_curls.png"),
    StrengthExercise('Podciąganie',"assets/pullups.png"),
  ];
}
