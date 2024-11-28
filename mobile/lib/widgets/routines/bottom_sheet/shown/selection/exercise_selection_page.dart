import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/session/active_session.dart";
import "package:pi_mobile/data/session/active_session_service_provider.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/selection/exercise_selection_entry.dart";

class ExerciseSelectionPage extends ConsumerWidget with Logger {
  final ActiveSession activeSession;

  const ExerciseSelectionPage({super.key, required this.activeSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Column(
            children: activeSession.exercises.indexed
                .map(
                  (exercise) => ExerciseSelectionEntry(
                    index: exercise.$1,
                    exercise: exercise.$2,
                  ),
                )
                .toList(),
          ),
          ElevatedButton(
            onPressed: () => _onEndWorkoutPressed(ref),
            child: Text(
              "End workout",
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.scheme.primary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );

  Future<void> _onEndWorkoutPressed(WidgetRef ref) async {
    final finishResult =
        await ref.read(activeSessionServiceProvider).finish().run();

    logger.debug("Finish result: $finishResult");
  }
}
