import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/data/strength_exercise_set_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:uuid/uuid.dart";

class ExerciseTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;

  const ExerciseTrainingScreen({
    super.key,
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
  });

  @override
  ConsumerState<ExerciseTrainingScreen> createState() =>
      _ExerciseTrainingScreen();
}

class _ExerciseTrainingScreen extends ConsumerState<ExerciseTrainingScreen> {
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
          widget.routineUuid,
          widget.workoutUuid,
          widget.exerciseUuid,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text("${context.t.routines.exercise}: ${widget.exerciseUuid}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
                      _restTimeController.text = exercise.restTime.toString();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: context.t.routines.exerciseName,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _restTimeController,
                            decoration: InputDecoration(
                              labelText: context.t.routines.restTime,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 500,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: exercise.sets.length,
                              itemBuilder: (context, index) {
                                final set = exercise.sets[index];
                                return ListTile(
                                  title: Text(
                                    "${context.t.routines.set}"
                                    " ${index + 1}",
                                  ),
                                  subtitle:
                                      Text("${context.t.routines.intensity}:"
                                          " ${set.intensity} \n"
                                          "${context.t.routines.reps}:"
                                          " ${set.reps}"),
                                  onTap: () {
                                    _onTap(
                                      context,
                                      widget.routineUuid,
                                      widget.workoutUuid,
                                      widget.exerciseUuid,
                                      set.uuid,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: Text(context.t.routines.noDataAvailable),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _addNewSet(context);
              },
              heroTag: "fab1",
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 80,
            child: FloatingActionButton(
              onPressed: () {
                _onSaveButtonPressed(context);
              },
              heroTag: "fab2",
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewSet(BuildContext context) async {
    final newSet = StrengthExerciseSetSchema(
      reps: 8,
      intensity: 70,
      uuid: const Uuid().v4(),
    );
    await ref.read(routinesProvider.notifier).addExerciseSet(
          widget.routineUuid,
          widget.workoutUuid,
          widget.exerciseUuid,
          newSet,
        );

    if (context.mounted) {
      EditExerciseSetSchemaRoute(
        routineUuid: widget.routineUuid,
        workoutUuid: widget.workoutUuid,
        exerciseUuid: widget.exerciseUuid,
        exerciseSetUuid: newSet.uuid,
      ).go(context);
    }
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
  }

  void _onTap(
    BuildContext context,
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
    String setUuid,
  ) {
    EditExerciseSetSchemaRoute(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
      exerciseSetUuid: setUuid,
    ).go(context);
  }
}
