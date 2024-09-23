import 'package:flutter/material.dart';
import 'package:pi_mobile/data/strength_exercise.dart';
import 'package:pi_mobile/data/workload.dart';

import 'package:pi_mobile/data/set_of_exercise.dart';
import 'exercise_summary_screen.dart';

class PendingExerciseScreen extends StatefulWidget {
  final StrengthExercise exercise;

  const PendingExerciseScreen(this.exercise, {super.key});

  @override
  _PendingExerciseScreenState createState() => _PendingExerciseScreenState();
}

class _PendingExerciseScreenState extends State<PendingExerciseScreen> {
  int currentSeries = 1;
  int repetitions = 10;
  double weight = 20;
  double difficulty = 5;

  List<SetOfExercise> workload = [];

  @override
  Widget build(BuildContext context) {
    StrengthExercise exercise = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text('Seria $currentSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      repetitions = (repetitions > 0) ? repetitions - 1 : 0;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ilość powtórzeń',
                    ),
                    textAlign: TextAlign.center,
                    controller:
                        TextEditingController(text: repetitions.toString()),
                    onChanged: (value) {
                      setState(() {
                        repetitions = int.tryParse(value) ?? repetitions;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      repetitions++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      weight = (weight > 0) ? weight - 1 : 0;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ilość kilogramów',
                    ),
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: weight.toString()),
                    onChanged: (value) {
                      setState(() {
                        weight = weight;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      weight++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('RPE: ${difficulty.toInt()}'),
            Slider(
              value: difficulty,
              min: 1,
              max: 10,
              divisions: 9,
              label: difficulty.round().toString(),
              onChanged: (double value) {
                setState(() {
                  difficulty = value;
                });
              },
              activeColor: getRPEAxleColor(difficulty),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                workload.add(
                  SetOfExercise(reps: repetitions, weight: weight, rpe: difficulty.toInt())
                );
                setState(() {
                  currentSeries++;
                });
              },
              child: const Text('Kolejna seria'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final pendingResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseSummaryScreen(
                        workoutData: Workload(exercise: exercise, sets: workload, description: "")),
                  ),
                );
                Navigator.pop(context, pendingResult);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Zakończ ćwiczenie'),
            ),
          ],
        ),
      ),
    );
  }

  Color getRPEAxleColor(double difficulty) {
    if (difficulty <= 5) {
      return Color.lerp(Colors.green, Colors.yellow, (difficulty - 1) / 4)!;
    } else {
      return Color.lerp(Colors.yellow, Colors.red, (difficulty - 5) / 5)!;
    }
  }
}
