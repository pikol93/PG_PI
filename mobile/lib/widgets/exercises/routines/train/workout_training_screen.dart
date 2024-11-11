import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/training.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/trainings_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class WorkoutTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String trainingUuid;

  const WorkoutTrainingScreen({
    super.key,
    required this.routineUuid,
    required this.trainingUuid,
  });

  @override
  ConsumerState<WorkoutTrainingScreen> createState() =>
      _WorkoutTrainingScreen();
}

class _WorkoutTrainingScreen extends ConsumerState<WorkoutTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final trainingFuture =
        ref.read(trainingsProvider.notifier).readTraining(widget.trainingUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("EGESZEGE RUSZAMY"),
      ),
      body: FutureBuilder<Training>(
        future: trainingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final training = snapshot.data!;

            if (training.trainingWorkload.trainingExercises.isEmpty) {
              return const Center(
                child: Text(
                  "No exercises available",
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount:
                        training.trainingWorkload.trainingExercises.length,
                    itemBuilder: (context, index) {
                      final exercise =
                          training.trainingWorkload.trainingExercises[index];
                      return Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              tileColor: exercise.isFinished
                                  ? Colors.green
                                  : Colors.white70,
                              title: Text(exercise.name),
                              subtitle: Text(
                                "${context.t.routines.amountOfSets}: "
                                "${exercise.exerciseSets.length}",
                              ),
                              onTap: !exercise.isFinished
                                  ? () {
                                      _onTap(
                                        context,
                                        widget.trainingUuid,
                                        exercise.trainingExerciseUuid,
                                      );
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _onEndTrainingButtonPressed(context, training.trainingUuid);
                  },
                  child: const Text("End Training"),
                ),
              ],
            );
          }

          return Center(child: Text(context.t.routines.noDataAvailable));
        },
      ),
    );
  }

  Future<void> _onEndTrainingButtonPressed(
    BuildContext context,
    String trainingUuid,
  ) async {
    await ref.read(trainingsProvider.notifier).endTraining(trainingUuid);
    if (context.mounted) {
      HistoryRecordRoute(trainingUuid: trainingUuid).go(context);
    }
  }

  void _onTap(
    BuildContext context,
    String trainingUuid,
    String exerciseUuid,
  ) {
    OpenExerciseTrainingRoute(
      trainingUuid: trainingUuid,
      exerciseUuid: exerciseUuid,
      routineUuid: widget.routineUuid,
    ).go(context);
  }
}
