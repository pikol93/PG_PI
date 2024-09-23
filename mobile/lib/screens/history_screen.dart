import 'package:flutter/material.dart';
import 'package:pi_mobile/data/workout.dart';

class HistoryScreen extends StatelessWidget {
  final List<Workout> sessionHistory;

  const HistoryScreen({super.key, required this.sessionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia treningów'),
      ),
      body: ListView.builder(
        itemCount: sessionHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sessionHistory[index].date.toString()),
            subtitle: Text(
                "Wykonanych ćwiczeń: ${sessionHistory[index].exercises.length}"),
          );
        },
      ),
    );
  }
}
