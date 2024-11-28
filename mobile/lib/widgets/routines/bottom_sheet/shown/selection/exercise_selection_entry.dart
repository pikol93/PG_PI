import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise/exercise_models_provider.dart";
import "package:pi_mobile/provider/session/active_session.dart";
import "package:pi_mobile/provider/session/active_session_service_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";
import "package:pi_mobile/widgets/routines/common/section_content.dart";

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

    final titleRowWidgets = <Widget>[
      Expanded(
        child: Text(
          exerciseName,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];

    if (exercise.isCompleted()) {
      titleRowWidgets.add(
        const Icon(
          Icons.check_circle_outline,
          color: Colors.greenAccent,
        ),
      );
    }

    return SectionContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: titleRowWidgets,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _onStartPressed(ref),
                child: exercise.isStarted()
                    ? const Text("Continue")
                    : const Text("Start"),
              ),
            ],
          ),
        ],
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
