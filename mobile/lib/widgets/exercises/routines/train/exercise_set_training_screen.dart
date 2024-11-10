import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
  final TextEditingController _rpeController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _rpeController.dispose();
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
                  _weightController.text = set.expectedWeight.toString();
                  _repsController.text = set.expectedReps.toString();
                  _rpeController.text = "7";

                  return Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: context.t.exercises.dataInput.reps,
                          border: const OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        controller: _repsController,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r"^(?!.*\.\..*)[0-9]*\.?[0-9]{0,2}$"),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: context.t.exercises.dataInput.weight,
                          border: const OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        controller: _weightController,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: "RPE",
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        controller: _rpeController,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _onSaveButtonPressed(context, set),
                        child: Text(context.t.exercises.dataInput.saveSet),
                      ),
                      const SizedBox(height: 10),
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
    BuildContext context,
    TrainingExerciseSet set,
  ) async {
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
