import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/session/active_session.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/selection/exercise_selection_page.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/set/set_page.dart";

class SheetBody extends StatelessWidget {
  final ActiveSession activeSession;

  const SheetBody({super.key, required this.activeSession});

  @override
  Widget build(BuildContext context) => activeSession.currentExerciseIndex
      .map<Widget>(
        (currentExerciseIndex) => SetPage(
          activeSession: activeSession,
          exerciseIndex: currentExerciseIndex,
        ),
      )
      .getOrElse(() => ExerciseSelectionPage(activeSession: activeSession));
}
