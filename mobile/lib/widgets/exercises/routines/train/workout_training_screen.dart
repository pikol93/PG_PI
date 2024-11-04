import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/widgets/common/exercises_list_widget.dart";

class WorkoutTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;

  const WorkoutTrainingScreen({
    super.key,
    required this.routineUuid,
    required this.workoutUuid,
  });

  @override
  ConsumerState<WorkoutTrainingScreen> createState() =>
      _WorkoutTrainingScreen();
}

class _WorkoutTrainingScreen extends ConsumerState<WorkoutTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutFuture = ref
        .read(routinesProvider.notifier)
        .getWorkout(widget.routineUuid, widget.workoutUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("EGESZEGE RUSZAMY"),
      ),
      body: FutureBuilder<WorkoutSchema>(
        future: workoutFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final workout = snapshot.data!;

            if (workout.exercisesSchemas.isEmpty) {
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
                  child: ExercisesListWidget(
                    exercises: workout.exercisesSchemas,
                    routineUuid: widget.routineUuid,
                    workoutUuid: widget.workoutUuid,
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
}
