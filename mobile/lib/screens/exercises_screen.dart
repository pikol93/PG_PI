import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/classes/workout.dart';
import 'package:pi_mobile/screens/workout_session_screen.dart';
import 'package:pi_mobile/widgets/app_navigation_drawer.dart';

class ExercisesScreen extends StatelessWidget {
  ExercisesScreen({super.key});

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
                  MaterialPageRoute(builder: (context) => WorkoutSessionScreen()),
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
                    builder: (context) => HistoryScreen(sessionHistory: sessionHistory),
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

class HistoryScreen extends StatelessWidget {
  final List<Workout> sessionHistory;

  HistoryScreen({required this.sessionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historia treningów'),
      ),
      body: ListView.builder(
        itemCount: sessionHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sessionHistory[index].date.toString()),
            subtitle: Text("Wykonanych ćwiczeń: ${sessionHistory[index].exercises.length}"),
          );
        },
      ),
    );
  }
}