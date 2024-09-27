import "package:flutter/material.dart";
import "package:pi_mobile/data/workload.dart";

class ExerciseSummaryScreen extends StatelessWidget {
  final Workload workoutData;

  const ExerciseSummaryScreen({super.key, required this.workoutData});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Podsumowanie"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Podsumowanie ćwiczenia:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: workoutData.sets.length,
                  itemBuilder: (context, index) {
                    final data = workoutData.sets[index];
                    return ListTile(
                      title: Text("Seria ${index + 1}"),
                      subtitle: Text(
                        "Powtórzenia: ${data.reps}, "
                        "Kilogramy: ${data.weight}, "
                        "Trudność: ${data.rpe}",
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
                child: const Text("Wróć"),
              ),
            ],
          ),
        ),
      );
}
