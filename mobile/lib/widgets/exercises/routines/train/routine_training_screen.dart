import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/workouts_list_widget.dart";
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
    final routineFuture =
        ref.read(routinesProvider.notifier).getRoutine(widget.routineUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Toja routine"),
      ),
      body: FutureBuilder<RoutineSchema>(
        future: routineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final routine = snapshot.data!;
            // _nameController.text = routine.name;
            // _descriptionController.text = routine.description;

            if (routine.workouts.isEmpty) {
              return const Center(child: Text("No workouts available"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: WorkoutsListWidget(
                    routineUuid: widget.routineUuid,
                    workouts: routine.workouts,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAddButtonPressed(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    final workoutUuid = const Uuid().v4();

    await ref.read(routinesProvider.notifier).addWorkout(
          widget.routineUuid,
          WorkoutSchema(uuid: workoutUuid, name: "", exercisesSchemas: []),
        );
    if (context.mounted) {
      OpenWorkoutTrainingRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: workoutUuid,
      ).go(context);
    }
  }
}
