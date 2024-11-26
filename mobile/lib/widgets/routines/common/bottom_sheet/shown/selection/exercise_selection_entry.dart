import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";

class ExerciseSelectionEntry extends ConsumerWidget with Logger {
  final int index;
  final ActiveSessionExercise exercise;

  const ExerciseSelectionEntry({
    super.key,
    required this.index,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseName = ref
        .watch(exerciseModelsMapProvider)
        .toOption()
        .map((map) => map.get(exercise.exerciseId))
        .flatten()
        .map((model) => model.name)
        .orElse("Exercise");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.scheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  exerciseName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("${exercise.sets.length} sets"), // TODO: I18N
              ),
              ElevatedButton(
                onPressed: () => _onStartPressed(ref),
                child: const Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onStartPressed(WidgetRef ref) async {
    logger.debug("Start pressed for exercise with index $index");
    final startResult =
        await ref.read(activeSessionServiceProvider).startExercise(index).run();

    logger.debug("Start pressed result: $startResult");
  }
}
