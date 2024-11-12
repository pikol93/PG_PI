// ignore_for_file: require_trailing_commas

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/schemas_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/workouts_list_widget.dart";
import "package:uuid/uuid.dart";

class EditRoutineSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;

  const EditRoutineSchemaScreen({super.key, required this.routineUuid});

  @override
  ConsumerState<EditRoutineSchemaScreen> createState() =>
      _EditRoutineSchemaScreenState();
}

class _EditRoutineSchemaScreenState
    extends ConsumerState<EditRoutineSchemaScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineFuture =
        ref.read(schemasProvider.notifier).getRoutine(widget.routineUuid);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.schema.modifyRoutineTitle),
      ),
      body: FutureBuilder<RoutineSchema>(
        future: routineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("${context.t.error.title}: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final routine = snapshot.data!;
            _nameController.text = routine.name;
            _descriptionController.text = routine.description;

            if (routine.workouts.isEmpty) {
              return Center(child: Text(context.t.error.noWorkouts));
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
                        decoration: InputDecoration(
                          labelText: context.t.schema.routineNameInput,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => _saveRoutineName(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: context.t.schema.description,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
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
          return Center(child: Text(context.t.error.noDataAvailable));
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

  Future<void> _saveRoutineName(BuildContext context) async {
    await ref.read(schemasProvider.notifier).updateRoutine(
          RoutineSchema(
            uuid: widget.routineUuid,
            name: _nameController.text,
            description: _descriptionController.text,
            workouts: [],
          ),
        );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    final workoutUuid = const Uuid().v4();

    await ref.read(schemasProvider.notifier).addWorkout(
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
