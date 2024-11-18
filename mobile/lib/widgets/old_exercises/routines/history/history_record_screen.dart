import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/data/training.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/trainings_provider.dart";

class HistoryRecordScreen extends ConsumerStatefulWidget {
  final String trainingUuid;
  static final dateFormat = DateFormat();

  const HistoryRecordScreen({required this.trainingUuid, super.key});

  @override
  ConsumerState<HistoryRecordScreen> createState() => _HistoryRecordScreen();
}

class _HistoryRecordScreen extends ConsumerState<HistoryRecordScreen> {
  @override
  Widget build(BuildContext context) {
    final trainingFuture =
        ref.read(trainingsProvider.notifier).getTraining(widget.trainingUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Details"),
      ),
      body: FutureBuilder<Training>(
        future: trainingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${context.t.error.title}: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text(context.t.error.noDataAvailable));
          }

          final training = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Training Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTrainingInfo(training),
                const SizedBox(height: 16),
                ...training.trainingWorkload.trainingExercises.map(
                  (exercise) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExerciseInfo(exercise),
                      const SizedBox(height: 8),
                      ...exercise.exerciseSets.map(_buildExerciseSetInfo),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrainingInfo(Training training) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Initial Workout Name: ${training.trainingName}"),
          Text("Training UUID: ${training.uuid}"),
          Text("Routine Schema UUID: ${training.routineSchemaUuid}"),
          Text("Workout Schema UUID: ${training.workoutSchemaUuid}"),
          Text("Start Date: ${training.startDate}"),
          Text("End Date: ${training.endDate}"),
          Text("Is Finished: ${training.isFinished}"),
          const SizedBox(height: 8),
          Text("""
Training Workload UUID: ${training.trainingWorkload.uuid}"""),
        ],
      );

  Widget _buildExerciseInfo(TrainingExercise exercise) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exercise UUID: ${exercise.trainingExerciseUuid}"),
          Text("Exercise Schema UUID: ${exercise.exerciseSchemaUuid}"),
          Text("Was Started: ${exercise.wasStarted}"),
          Text("Is Finished: ${exercise.isFinished}"),
        ],
      );

  Widget _buildExerciseSetInfo(TrainingExerciseSet set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exercise Set UUID: ${set.uuid}"),
          Text("Exercise Set Schema UUID: ${set.exerciseSetSchemaUuid}"),
          Text("Weight: ${set.weight} kg"),
          Text("Reps: ${set.reps}"),
          Text("Expected Reps: ${set.expectedReps}"),
          Text("Expected Weight: ${set.expectedWeight} kg"),
          Text("RPE: ${set.rpe}"),
          Text("Is Finished: ${set.isFinished}"),
        ],
      );
}
