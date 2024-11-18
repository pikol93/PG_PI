import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/schemas_provider.dart";
import "package:pi_mobile/provider/trainings_provider.dart";
import "package:pi_mobile/routing/routes_old_exercises.dart";

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
        title: Text(context.t.training.chooseYourWorkout),
      ),
      body: FutureBuilder<RoutineSchema>(
        future: schemaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${context.t.error.title}: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final routine = snapshot.data!;

            if (routine.workouts.isEmpty) {
              return Center(child: Text(context.t.error.noWorkouts));
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
          return Center(child: Text(context.t.error.noDataAvailable));
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
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: _builder,
        );
      }
    } else {
      final newTrainingUuid = await ref
          .read(trainingsProvider.notifier)
          .addEmptyTraining(routineUuid, workoutUuid);

      if (context.mounted) {
        OpenWorkoutTrainingRoute(
          trainingUuid: newTrainingUuid,
          routineUuid: routineUuid,
        ).go(context);
      }
    }
  }

  Widget _builder(BuildContext context) => AlertDialog(
        title: Text(context.t.routines.youDidntFinishLastTrainingMessage),
        actions: [
          TextButton(
            onPressed: () => context.navigator.pop(),
            child: Text(context.t.common.ok),
          ),
        ],
      );
}
