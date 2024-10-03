import "package:flutter/material.dart";
import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/i18n/strings.g.dart";


class ExerciseSummaryScreen extends StatelessWidget {
  final Workload workoutData;

  const ExerciseSummaryScreen({super.key, required this.workoutData});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.exercises.exerciseSummary.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: workoutData.sets.length,
                  itemBuilder: (context, index) {
                    final data = workoutData.sets[index];
                    return ListTile(
                      subtitle: Text(
                        "${context.t.exercises.exerciseSummary.reps}: ${data.reps}, "
                        "${context.t.exercises.exerciseSummary.weight}: ${data.weight}, "
                        "RPE: ${data.rpe}",
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    workoutData,
                  ); // Powrót do ekranu głównego
                },
                child: Text(context.t.exercises.back),
              ),
            ],
          ),
        ),
      );
}
