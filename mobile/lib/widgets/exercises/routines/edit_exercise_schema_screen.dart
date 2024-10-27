import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/data/strength_exercise_set_schema.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class EditExerciseSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;

  const EditExerciseSchemaScreen({
    super.key,
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
  });

  @override
  ConsumerState<EditExerciseSchemaScreen> createState() =>
      _EditExerciseSchemaScreen();
}

class _EditExerciseSchemaScreen
    extends ConsumerState<EditExerciseSchemaScreen> {
  final List<StrengthExerciseSetSchema> _sets = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _restTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseFuture = ref.read(routinesProvider.notifier).getExercise(
        widget.routineUuid, widget.workoutUuid, widget.exerciseUuid,);

    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise: ${widget.exerciseUuid}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            FutureBuilder<StrengthExerciseSchema>(
              future: exerciseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final exercise = snapshot.data!;
                  _nameController.text = exercise.name;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Edit Exercise Name"),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Exercise Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Text("Current Exercise: ${exercise.name}"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exercise.sets.length,
                        itemBuilder: (context, index) {
                          final exerciseSet = exercise.sets[index];
                          return ListTile(
                            title: Text("Set ${index + 1}"),
                            subtitle: Text(
                              "Reps: ${exerciseSet.reps}, "
                                  "Weight: ${exerciseSet.intensity}",
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addNewSet,
                          child: const Text("Add Set"),
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text("No data available"));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onSaveButtonPressed(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void _addNewSet() {
    final newSet =
        StrengthExerciseSetSchema(reps: 10, intensity: 20, no: _sets.length);
    _sets.add(newSet);
    setState(() {});
  }

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    await ref.read(routinesProvider.notifier).updateExercise(
          widget.routineUuid,
          widget.workoutUuid,
          StrengthExerciseSchema(
            uuid: widget.exerciseUuid,
            name: _nameController.text,
            restTime: int.tryParse(_restTimeController.text) ?? 100,
            sets: [],
          ),
        );

    if (context.mounted) {
      EditWorkoutSchemaRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: widget.workoutUuid,
      ).go(context);
    }
  }
}
