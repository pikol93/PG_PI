import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";

class ActiveSessionBottomSheetShownHeader extends ConsumerWidget with Logger {
  final ActiveSession activeSession;

  ActiveSessionBottomSheetShownHeader({super.key, required this.activeSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutName = ref
        .watch(routinesMapProvider)
        .toOption()
        .map((map) => map.get(activeSession.routineId))
        .flatten()
        .map(
          (routine) => routine.workouts
              .where((workout) => workout.id == activeSession.workoutId)
              .firstOption,
        )
        .flatten()
        .map((workout) => workout.name)
        .orElse("Workout");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _onHidePressed,
          icon: const Icon(Icons.expand_more),
        ),
        Expanded(
          child: Text(
            workoutName,
            textAlign: TextAlign.center,
            style: context.textStyles.titleLarge,
          ),
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => _onEndExercisePressed(ref),
              child: const Text("End exercise"), // TODO: I18N
            ),
            PopupMenuItem(
              onTap: () => _onEndWorkoutPressed(ref),
              child: const Text("End workout"), // TODO: I18N
            ),
          ],
        ),
      ],
    );
  }

  void _onHidePressed() {
    logger.debug("Hide pressed.");
  }

  Future<void> _onEndExercisePressed(WidgetRef ref) async {
    logger.debug("Skip exercise tapped");
    await ref.read(activeSessionServiceProvider).endExercise().run();
  }

  Future<void> _onEndWorkoutPressed(WidgetRef ref) async {
    logger.debug("End workout pressed");
    final finishResult =
        await ref.read(activeSessionServiceProvider).finish().run();

    logger.debug("Active sesion finish result: $finishResult");
  }
}
