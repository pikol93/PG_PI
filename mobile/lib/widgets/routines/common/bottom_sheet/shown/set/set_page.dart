import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/list.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/set/exercise_completed_page.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/set/set_in_progress_page.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/set/set_resting_page.dart";

class SetPage extends ConsumerWidget {
  final ActiveSession activeSession;
  final int exerciseIndex;

  const SetPage({
    super.key,
    required this.activeSession,
    required this.exerciseIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => activeSession.exercises
      .get(exerciseIndex)
      .map<Option<Widget>>(
        (exercise) {
          final exerciseName = ref
              .watch(exerciseModelsMapProvider)
              .toOption()
              .map((map) => map.get(exercise.exerciseId))
              .flatten()
              .map((exercise) => exercise.name)
              .orElse("Exercise");

          return exercise.sets.indexed
              .map<Option<Widget>>(
                (set) => switch (set.$2.result) {
                  ToBeDone() => Option.of(
                      SetInProgressPage(
                        exerciseName: exerciseName,
                        activeSession: activeSession,
                        set: set.$2,
                        exerciseIndex: exerciseIndex,
                        setIndex: set.$1,
                        setTotalCount: exercise.sets.length,
                        expectedWeight: set.$2.expectedWeight,
                      ),
                    ),
                  Rest(:final restStart) => Option.of(
                      SetRestingPage(
                        exerciseName: exerciseName,
                        activeSession: activeSession,
                        exerciseIndex: exerciseIndex,
                        setIndex: set.$1,
                        setTotalCount: exercise.sets.length,
                        restStart: restStart,
                        restEnd: restStart.add(
                          Duration(seconds: set.$2.expectedRestTimeSeconds),
                        ),
                      ),
                    ),
                  _ => const Option.none(),
                },
              )
              .where((value) => value.isSome())
              .firstOption
              .flatten();
        },
      )
      .flatten()
      .orElse(const ExerciseCompletedPage());
}
