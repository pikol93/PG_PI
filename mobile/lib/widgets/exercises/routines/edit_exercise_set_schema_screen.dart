import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_set_schema.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class EditExerciseSetSchemaScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;
  final String exerciseSetUuid;

  const EditExerciseSetSchemaScreen({
    super.key,
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
    required this.exerciseSetUuid,
  });

  @override
  ConsumerState<EditExerciseSetSchemaScreen> createState() =>
      _EditExerciseSetSchemaScreen();
}

class _EditExerciseSetSchemaScreen
    extends ConsumerState<EditExerciseSetSchemaScreen> {
  final TextEditingController _intensityController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void dispose() {
    _intensityController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setFuture = ref.read(routinesProvider.notifier).getExerciseSet(
        widget.routineUuid,
        widget.workoutUuid,
        widget.exerciseUuid,
        widget.exerciseSetUuid,);

    return Scaffold(
      appBar: AppBar(
        title: Text("Set: ${widget.exerciseSetUuid}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            FutureBuilder<StrengthExerciseSetSchema>(
              future: setFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final set = snapshot.data!;
                  _intensityController.text = set.intensity.toString();
                  _repsController.text = set.reps.toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Edit Exercise Name"),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _intensityController,
                        decoration: const InputDecoration(
                          labelText: "Intensity: ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _repsController,
                        decoration: const InputDecoration(
                          labelText: "Reps: ",
                          border: OutlineInputBorder(),
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

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    await ref.read(routinesProvider.notifier).updateExerciseSet(
          widget.routineUuid,
          widget.workoutUuid,
          widget.exerciseUuid,
          StrengthExerciseSetSchema(
            uuid: widget.exerciseUuid,
            reps: int.tryParse(_repsController.text) ?? 100,
            intensity: int.tryParse(_intensityController.text) ?? 80,
          ),
        );

    if (context.mounted) {
      EditExerciseSchemaRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: widget.workoutUuid,
        exerciseUuid: widget.exerciseUuid,
      ).go(context);
    }
  }
}
