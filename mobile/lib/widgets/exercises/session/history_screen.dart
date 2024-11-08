import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/provider/trainings_provider.dart";

import "../../../i18n/strings.g.dart";

class HistoryScreen extends ConsumerWidget {
  static final dateFormat = DateFormat();

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.exercises.history),
        ),
        body: ref.watch(trainingsProvider).when(
              error: (error, stack) =>
                  Text("Could not fetch trainings. $error"),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (trainings) => ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: trainings.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(trainings[index].startDate.toString()),
                  subtitle: Text(
                    "${context.t.exercises.amountOfPerformedExercises}:"
                    " ${trainings[index].initialWorkoutName}",
                  ),
                ),
              ),
            ),
      );
}
