import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/data/workout.dart';
import 'package:pi_mobile/screens/workout_session_screen.dart';
import 'package:pi_mobile/widgets/app_navigation_drawer.dart';

import 'history_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Workout> sessionHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Ćwiczenia"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkoutSessionScreen()),
                );

                if (result != null) {
                  sessionHistory.add(result);
                }
              },
              child: const Text('Rozpocznij nowy trening'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryScreen(sessionHistory: sessionHistory),
                  ),
                );
              },
              child: const Text('Zobacz historię treningów'),
            ),
          ],
        ),
      ),
    );
  }
}
