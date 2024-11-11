import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/training.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/data/training_workload.dart";
import "package:pi_mobile/provider/one_rep_max_provider.dart";
import "package:pi_mobile/provider/schemas_provider.dart";
import "package:pi_mobile/provider/trainings_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:uuid/uuid.dart";

class RoutineTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;

  const RoutineTrainingScreen({super.key, required this.routineUuid});

  @override
  ConsumerState<RoutineTrainingScreen> createState() =>
      _RoutineTrainingScreenState();
}

class _RoutineTrainingScreenState extends ConsumerState<RoutineTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final schemaFuture =
        ref.read(schemasProvider.notifier).getRoutine(widget.routineUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your workout"),
      ),
      body: FutureBuilder<RoutineSchema>(
        future: schemaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final routine = snapshot.data!;

            if (routine.workouts.isEmpty) {
              return const Center(child: Text("No workouts available"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: routine.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = routine.workouts[index];
                      return ListTile(
                        title: Text(workout.name),
                        subtitle: Text(workout.uuid),
                        onTap: () {
                          _onTap(context, widget.routineUuid, workout.uuid);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    String routineUuid,
    String workoutUuid,
  ) async {
    final isAnyPendingTraining =
        await ref.read(trainingsProvider.notifier).isAnyPendingTraining();

    if (isAnyPendingTraining) {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: _builder,
      );
    } else {
      final newTraining =
          await prepareTrainingToAddition(routineUuid, workoutUuid);

      await ref.read(trainingsProvider.notifier).addTraining(newTraining);

      if (context.mounted) {
        OpenWorkoutTrainingRoute(
          trainingUuid: newTraining.trainingUuid,
          routineUuid: routineUuid,
        ).go(context);
      }
    }
  }

  Future<Training> prepareTrainingToAddition(
    String routineUuid,
    String workoutUuid,
  ) async {
    final routineSchema =
        await ref.read(schemasProvider.notifier).getRoutine(routineUuid);

    final workoutSchema = await ref
        .read(schemasProvider.notifier)
        .getWorkout(routineUuid, workoutUuid);

    final trainingExercisesBlank = <TrainingExercise>[];
    for (final exerciseSchema in workoutSchema.exercisesSchemas) {
      final trainingExerciseSetsBlank = <TrainingExerciseSet>[];

      final oneRepMax = await ref
          .read(oneRepMaxsProvider.notifier)
          .getCertainOneRepMax(exerciseSchema.name);

      for (final exerciseSchemaSet in exerciseSchema.sets) {
        trainingExerciseSetsBlank.add(
          TrainingExerciseSet(
            trainingExerciseSetUuid: const Uuid().v4(),
            exerciseSetSchemaUuid: exerciseSchemaSet.uuid,
            weight: 0,
            reps: 0,
            expectedReps: exerciseSchemaSet.reps,
            expectedWeight: (exerciseSchemaSet.intensity * 0.01 * oneRepMax)
                .floorToDouble(),
            rpe: 0,
            isFinished: false,
            exerciseName: exerciseSchema.name,
          ),
        );
      }

      trainingExercisesBlank.add(
        TrainingExercise(
          name: exerciseSchema.name,
          trainingExerciseUuid: const Uuid().v4(),
          exerciseSchemaUuid: exerciseSchema.uuid,
          wasStarted: false,
          isFinished: false,
          exerciseSets: trainingExerciseSetsBlank,
        ),
      );
    }

    final trainingUuid = const Uuid().v4();

    return Training(
      initialTrainingName: workoutSchema.name,
      trainingUuid: trainingUuid,
      routineSchemaUuid: routineUuid,
      workoutSchemaUuid: workoutUuid,
      startDate: DateTime.now(),
      endDate: DateTime(2023),
      isFinished: false,
      trainingWorkload: TrainingWorkload(
        trainingWorkloadUuid: const Uuid().v4(),
        workoutSchemaUuid: workoutUuid,
        trainingExercises: trainingExercisesBlank,
      ),
      initialRoutineName: routineSchema.name,
    );
  }

  Widget _builder(BuildContext context) => AlertDialog(
        title: const Text(
          "Nie ukończyłeś poprzedniego treningu,"
              " najpierw go zakończ w historii",
        ),
        actions: [
          TextButton(
            onPressed: () => context.navigator.pop(),
            child: const Text("Zamknij"),
          ),
        ],
      );
}
