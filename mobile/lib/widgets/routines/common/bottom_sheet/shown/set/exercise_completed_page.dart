import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";

class ExerciseCompletedPage extends ConsumerWidget with Logger {
  const ExerciseCompletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          const Text("Exercise completed."), // TODO: I18N
          ElevatedButton(
            onPressed: () => _doAnotherSetPressed(ref),
            child: const Text("Do another set"), // TODO: I18N
          ),
          ElevatedButton(
            onPressed: () => _onSelectExercisePressed(ref),
            child: const Text("Go to exercise selection page"), // TODO: I18N
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
