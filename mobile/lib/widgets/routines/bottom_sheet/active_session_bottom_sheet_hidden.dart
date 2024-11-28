import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/provider/session/active_session.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";

class ActiveSessionBottomSheetHidden extends ConsumerWidget with Logger {
  final ActiveSession activeSession;
  final void Function() onShowPressed;

  const ActiveSessionBottomSheetHidden({
    super.key,
    required this.activeSession,
    required this.onShowPressed,
  });

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
        .orElse("UNKNOWN");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _onShowPressed,
              icon: const Icon(Icons.expand_less),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                workoutName,
                style: context.textStyles.bodyLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onShowPressed() {
    logger.debug("Show pressed.");
    onShowPressed();
  }
}
