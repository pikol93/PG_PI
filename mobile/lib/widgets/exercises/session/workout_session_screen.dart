import 'package:flutter/material.dart';

import 'package:pi_mobile/data/workload.dart';
import 'package:pi_mobile/data/workout.dart';
import 'choose_exercise_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  _WorkoutSessionScreenState createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  final List<Workload> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesja Treningowa'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                Workload workload = exercises[index];
                return ListTile(
                  title: Text(workload.exercise.name),
                  subtitle: Text(
                      'Średnie RPE: ${Workload.getAverageRPE(workload.sets)}, Notatka: ${workload.description}'),
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
                      builder: (context) => const ChooseExerciseScreen()),
                );

                if (result != null) {
                  setState(() {
                    exercises.add(result);
                  });
                }
              },
              child: const Text('Dodaj ćwiczenie'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context, Workout(date: DateTime.now(), exercises: exercises));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Zakończ sesję'),
          ),
        ],
      ),
    );
  }
}
