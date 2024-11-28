import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/trainings_provider.dart";
import "package:pi_mobile/routing/routes_old_exercises.dart";

class ExerciseTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String trainingUuid;
  final String exerciseUuid;

  const ExerciseTrainingScreen({
    super.key,
    required this.routineUuid,
    required this.trainingUuid,
    required this.exerciseUuid,
  });

  @override
  ConsumerState<ExerciseTrainingScreen> createState() =>
      _ExerciseTrainingScreen();
}

class _ExerciseTrainingScreen extends ConsumerState<ExerciseTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseFuture = ref.read(trainingsProvider.notifier).getExercise(
          widget.trainingUuid,
          widget.exerciseUuid,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                FutureBuilder<TrainingExercise>(
                  future: exerciseFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "${context.t.error.title}: ${snapshot.error}",
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final exercise = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 500,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: exercise.exerciseSets.length,
                              itemBuilder: (context, index) {
                                final set = exercise.exerciseSets[index];
                                return ListTile(
                                  tileColor: set.isFinished
                                      ? Colors.lightGreen
                                      : Colors.white54,
                                  title: Text(
                                    "${context.t.routines.set}"
                                    " ${index + 1}",
                                  ),
                                  subtitle: getListTileSubtitle(set),
                                  onTap: !set.isFinished
                                      ? () {
                                          _onTap(
                                            context,
                                            widget.routineUuid,
                                            widget.trainingUuid,
                                            widget.exerciseUuid,
                                            set.uuid,
                                          );
                                        }
                                      : null,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: Text(context.t.routines.noDataAvailable),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text getListTileSubtitle(TrainingExerciseSet set) {
    if (!set.isFinished) {
      return Text("${context.t.routines.intensity}: "
          "${set.expectedIntensity}% 1RM\n"
          "${context.t.routines.expectedReps}: "
          "${set.expectedReps} \n");
    } else {
      return Text("${context.t.exercises.dataInput.weight}: "
          "${set.weight} kg\n"
          "${context.t.routines.reps}: "
          "${set.reps} \n");
    }
  }

  void _onTap(
    BuildContext context,
    String routineUuid,
    String trainingUuid,
    String exerciseUuid,
    String setUuid,
  ) {
    OpenExerciseSetTrainingRoute(
      routineUuid: routineUuid,
      trainingUuid: trainingUuid,
      exerciseUuid: exerciseUuid,
      exerciseSetUuid: setUuid,
    ).go(context);
  }
}
