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
        ref.read(trainingsProvider.notifier).getTraining(widget.trainingUuid);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.training.title),
      ),
      body: FutureBuilder<Training>(
        future: trainingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${context.t.error.title}:"
                  " ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final training = snapshot.data!;

            if (training.trainingWorkload.trainingExercises.isEmpty) {
              return Center(
                child: Text(context.t.error.noExercises),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
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
                                  ? Colors.lightGreen
                                  : Colors.white54,
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
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _onEndTrainingButtonPressed(
                        context,
                        training.uuid,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: Text(context.t.training.endTraining),
                  ),
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
