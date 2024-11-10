import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/trainings_provider.dart";

class ExerciseTrainingScreen extends ConsumerStatefulWidget {
  final String trainingUuid;
  final String exerciseUuid;

  const ExerciseTrainingScreen({
    super.key,
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
    final exerciseFuture = ref.read(trainingsProvider.notifier).readExercise(
          widget.trainingUuid,
          widget.exerciseUuid,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text("${context.t.routines.exercise}: ${widget.exerciseUuid}"),
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
                      return Center(child: Text("Error: ${snapshot.error}"));
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
                                  title: Text(
                                    "${context.t.routines.set}"
                                    " ${index + 1}",
                                  ),
                                  subtitle:
                                      Text("${context.t.routines.intensity}:"
                                          " ${set.weight} \n"
                                          "${context.t.routines.reps}:"
                                          " ${set.reps}"),
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
}
