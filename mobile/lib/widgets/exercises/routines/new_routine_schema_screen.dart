import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:uuid/uuid.dart";

class NewRoutineSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;

  const NewRoutineSchemaScreen({super.key, required this.routineUuid});

  @override
  ConsumerState<NewRoutineSchemaScreen> createState() =>
      _NewRoutineSchemaScreenState();
}

class _NewRoutineSchemaScreenState
    extends ConsumerState<NewRoutineSchemaScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutsFuture =
        ref.read(routinesProvider.notifier).getWorkouts(widget.routineUuid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Workouts for Routine: ${widget.routineUuid}"),
      ),
      body: FutureBuilder<List<WorkoutSchema>>(
        future: workoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final workouts = snapshot.data!;

            if (workouts.isEmpty) {
              return const Center(child: Text("No workouts available"));
            }

            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text("${workout.exercisesSchemas.length}"),
                );
              },
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
      EditWorkoutSchemaRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: workoutUuid,
      ).go(context);
    }
  }
}
