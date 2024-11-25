import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";

class ActiveSessionBottomSheetHidden extends ConsumerWidget {
  final ActiveSession activeSession;

  const ActiveSessionBottomSheetHidden({
    super.key,
    required this.activeSession,
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

    final exerciseName = ref
        .watch(exerciseModelsMapProvider)
        .toOption()
        .map((map) => map.get(1000000000))
        .flatten()
        .map((model) => model.name)
        .orElse("");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(workoutName),
        Text(exerciseName),
      ],
    );
  }
}
