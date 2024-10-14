import "package:flutter/material.dart";
import "package:pi_mobile/data/workout.dart";
import "package:pi_mobile/i18n/strings.g.dart";

class HistoryScreen extends StatelessWidget {
  final List<Workout> sessionHistory;

  const HistoryScreen({super.key, required this.sessionHistory});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.exercises.history),
        ),
        body: ListView.builder(
          itemCount: sessionHistory.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(sessionHistory[index].date.toString()),
            subtitle: Text(
              "${context.t.exercises.amountOfPerformedExercises}:"
              " ${sessionHistory[index].exercises.length}",
            ),
          ),
        ),
      );
}
