import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/trainings_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class ExerciseSetTrainingScreen extends ConsumerStatefulWidget {
  final String routineUuid;
  final String trainingUuid;
  final String exerciseUuid;
  final String exerciseSetUuid;

  const ExerciseSetTrainingScreen({
    super.key,
    required this.routineUuid,
    required this.trainingUuid,
    required this.exerciseUuid,
    required this.exerciseSetUuid,
  });

  @override
  ConsumerState<ExerciseSetTrainingScreen> createState() =>
      _ExerciseSetTrainingScreen();
}

class _ExerciseSetTrainingScreen
    extends ConsumerState<ExerciseSetTrainingScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setFuture = ref.read(trainingsProvider.notifier).readExerciseSet(
          widget.trainingUuid,
          widget.exerciseUuid,
          widget.exerciseSetUuid,
        );

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
            FutureBuilder<TrainingExerciseSet>(
              future: setFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final set = snapshot.data!;
                  _weightController.text = set.weight.toString();
                  _repsController.text = set.reps.toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t.routines.editExerciseName),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: context.t.routines.intensity,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _repsController,
                        decoration: InputDecoration(
                          labelText: context.t.routines.reps,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => _onSaveButtonPressed(context, set),
                        child: const Text("Zapisz"),
                      ),
                    ],
                  );
                }

                return Center(child: Text(context.t.routines.noDataAvailable));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveButtonPressed(
      BuildContext context, TrainingExerciseSet set,) async {
    final newSet = set.copyWith(
      reps: int.tryParse(_repsController.text) ?? 100,
      weight: double.tryParse(_weightController.text) ?? 100,
      isFinished: true,
    );

    await ref
        .read(trainingsProvider.notifier)
        .updateExerciseSet(widget.trainingUuid, widget.exerciseUuid, newSet);

    if (context.mounted) {
      OpenExerciseTrainingRoute(
        routineUuid: widget.routineUuid,
        trainingUuid: widget.trainingUuid,
        exerciseUuid: widget.exerciseUuid,
      ).go(context);
    }
  }
}
