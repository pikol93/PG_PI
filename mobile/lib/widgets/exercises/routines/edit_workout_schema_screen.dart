import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/exercises_list_widget.dart";
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
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutFuture = ref
        .read(routinesProvider.notifier)
        .getWorkout(widget.routineUuid, widget.workoutUuid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Workout: ${widget.workoutUuid}"),
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

            _nameController.text = workout.name;

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
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Nazwa workoutu",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => _saveWorkoutName(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAddButtonPressed(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _saveWorkoutName(BuildContext context) async {
    await ref.read(routinesProvider.notifier).updateWorkout(
          widget.routineUuid,
          WorkoutSchema(
            uuid: widget.workoutUuid,
            name: _nameController.text,
            exercisesSchemas: [],
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