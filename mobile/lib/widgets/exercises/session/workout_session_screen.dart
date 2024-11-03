import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:uuid/uuid.dart";

import "choose_exercise_screen.dart";

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  final List<Workload> exercises = [];
  final String workoutUuid = const Uuid().v4();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.exercises.trainingSession),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final workload = exercises[index];
                  return ListTile(
                    title: Text(workload.exercise.name),
                    subtitle: Text(
                      "${context.t.exercises.averageRPE}:"
                      " ${Workload.getAverageRPE(workload.sets)},"
                      " ${context.t.exercises.notes}:"
                      " ${workload.description}",
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChooseExerciseScreen(workoutUuid: workoutUuid),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      exercises.add(result);
                    });
                  }
                },
                child: Text(context.t.exercises.addExercise),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(context.t.exercises.endWorkout),
            ),
          ],
        ),
      );
}
