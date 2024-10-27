import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:uuid/uuid.dart";

class EditWorkoutSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;

  const EditWorkoutSchemaScreen({
    super.key,
    required this.routineUuid,
    required this.workoutUuid,
  });

  @override
  ConsumerState<EditWorkoutSchemaScreen> createState() =>
      _EditWorkoutSchemaScreen();
}

class _EditWorkoutSchemaScreen extends ConsumerState<EditWorkoutSchemaScreen> {
  @override
  Widget build(BuildContext context) {
    final exercisesFuture = ref
        .read(routinesProvider.notifier)
        .getExercises(widget.routineUuid, widget.workoutUuid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Workout: ${widget.workoutUuid}"),
      ),
      body: FutureBuilder<List<StrengthExerciseSchema>>(
        future: exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final exercises = snapshot.data!;

            if (exercises.isEmpty) {
              return Center(
                child: Text(
                  "No workouts available ${widget.routineUuid}"
                  " ${widget.workoutUuid}",
                ),
              );
            }

            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text("${exercises.length}"),
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
    final exerciseUuid = const Uuid().v4();

    await ref.read(routinesProvider.notifier).addExercise(
          widget.routineUuid,
          widget.workoutUuid,
          StrengthExerciseSchema(
            uuid: exerciseUuid,
            name: "",
            restTime: 100,
            sets: [],
          ),
        );

    if (context.mounted) {
      EditExerciseSchemaRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: widget.workoutUuid,
        exerciseUuid: exerciseUuid,
      ).go(context);
    }
  }
}
