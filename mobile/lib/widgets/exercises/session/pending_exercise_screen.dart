import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/set_of_exercise.dart";
import "package:pi_mobile/data/strength_exercise.dart";
import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/workouts_provider.dart";

import "exercise_summary_screen.dart";

class PendingExerciseScreen extends ConsumerStatefulWidget {
  final StrengthExercise exercise;
  final String workoutUuid;

  const PendingExerciseScreen(this.exercise, this.workoutUuid, {super.key});

  @override
  ConsumerState<PendingExerciseScreen> createState() =>
      _PendingExerciseScreenState();
}

class _PendingExerciseScreenState extends ConsumerState<PendingExerciseScreen> {
  int currentSeries = 1;
  int repetitions = 10;
  double weight = 20;
  double difficulty = 5;

  List<SetOfExercise> workload = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("${context.t.exercises.dataInput.set} $currentSeries"),
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
                      decoration: InputDecoration(
                        labelText: context.t.exercises.dataInput.reps,
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
                      decoration: InputDecoration(
                        labelText: context.t.exercises.dataInput.weight,
                      ),
                      textAlign: TextAlign.center,
                      controller:
                          TextEditingController(text: weight.toString()),
                      onChanged: (value) {
                        setState(() {});
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
              Text("RPE: ${difficulty.toInt()}"),
              Slider(
                value: difficulty,
                min: 1,
                max: 10,
                divisions: 9,
                label: difficulty.round().toString(),
                onChanged: (value) {
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
                    SetOfExercise(
                      reps: repetitions,
                      weight: weight,
                      rpe: difficulty.toInt(),
                    ),
                  );
                  setState(() {
                    currentSeries++;
                  });
                },
                child: Text(context.t.exercises.dataInput.saveSet),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pendingResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseSummaryScreen(
                        workoutData: Workload(
                          exercise: widget.exercise,
                          sets: workload,
                          description: widget.workoutUuid,
                        ),
                      ),
                    ),
                  );

                  if (context.mounted) {
                    await ref.read(workoutsProvider.notifier).addWorkload(
                          widget.workoutUuid,
                          Workload(
                            exercise: widget.exercise,
                            sets: workload,
                            description: "",
                          ),
                        );
                    Navigator.pop(context, pendingResult);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Text(context.t.exercises.dataInput.endExercise),
              ),
            ],
          ),
        ),
      );

  Color getRPEAxleColor(double difficulty) {
    if (difficulty <= 5) {
      return Color.lerp(Colors.green, Colors.yellow, (difficulty - 1) / 4)!;
    } else {
      return Color.lerp(Colors.yellow, Colors.red, (difficulty - 5) / 5)!;
    }
  }
}
