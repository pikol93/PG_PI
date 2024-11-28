import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/session/active_session_service_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";

class ExerciseCompletedPage extends ConsumerWidget with Logger {
  const ExerciseCompletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Text(context.t.routines.exercise.completed),
          ElevatedButton(
            onPressed: () => _doAnotherSetPressed(ref),
            child: Text(context.t.routines.exercise.doAnotherSet),
          ),
          ElevatedButton(
            onPressed: () => _onSelectExercisePressed(ref),
            child: Text(context.t.routines.exercise.selectAnother),
          ),
        ],
      );

  Future<void> _doAnotherSetPressed(WidgetRef ref) async {
    final anotherSetResult = await ref
        .read(activeSessionServiceProvider)
        .addEmptySetToCurrentExercise()
        .run();
    logger.debug("Another set pressed result: $anotherSetResult");
  }

  Future<void> _onSelectExercisePressed(WidgetRef ref) async {
    final endExerciseResult =
        await ref.read(activeSessionServiceProvider).endExercise().run();
    logger.debug("End exercise result: $endExerciseResult");
  }
}
