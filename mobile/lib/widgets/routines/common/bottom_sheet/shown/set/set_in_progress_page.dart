import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";
import "package:pi_mobile/widgets/common/number_input.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/set/common/exercise_name_header.dart";
import "package:pi_mobile/widgets/routines/common/bottom_sheet/shown/set/common/set_count_subheader.dart";

class SetInProgressPage extends ConsumerStatefulWidget {
  final String exerciseName;
  final ActiveSession activeSession;
  final ActiveSessionSet set;
  final int exerciseIndex;
  final int setIndex;
  final int setTotalCount;

  const SetInProgressPage({
    super.key,
    required this.exerciseName,
    required this.activeSession,
    required this.set,
    required this.exerciseIndex,
    required this.setIndex,
    required this.setTotalCount,
  });

  @override
  ConsumerState<SetInProgressPage> createState() => _SetInProgressPageState();
}

class _SetInProgressPageState extends ConsumerState<SetInProgressPage>
    with Logger {
  late final NumberValueNotifier weightValueNotifier;
  late final NumberValueNotifier repsValueNotifier;

  @override
  void initState() {
    super.initState();

    weightValueNotifier = NumberValueNotifier(
      initialValue: widget.set.expectedIntensity,
      delta: 2.5,
      minValueRaw: 0.0,
    );

    repsValueNotifier = NumberValueNotifier(
      initialValue: widget.set.expectedReps.toDouble(),
      delta: 1,
      minValueRaw: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExerciseNameHeader(exerciseName: widget.exerciseName),
          SetCountSubheader(
            setIndex: widget.setIndex,
            setTotalCount: widget.setTotalCount,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NumberInput(
                  title: "Weight", // TODO: I18N
                  formatter: _formatWeight,
                  valueNotifier: weightValueNotifier,
                ),
                NumberInput(
                  title: "Reps", // TODO: I18N
                  formatter: _formatReps,
                  valueNotifier: repsValueNotifier,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _onSetDonePressed,
            child: const Text("Set done"), // TODO: I18N
          ),
        ],
      );

  String _formatWeight(double value) => "${value.toStringAsFixed(1)} kg";

  String _formatReps(double value) => "${value.round()}";

  Future<void> _onSetDonePressed() async {
    final result = await ref
        .watch(activeSessionServiceProvider)
        .beginResting(
          widget.setIndex,
          ActiveSessionSetResult(
            weight: weightValueNotifier.value,
            reps: repsValueNotifier.value.round(),
            rpe: 0,
          ),
        )
        .run();

    logger.debug(
      "Set done pressed for exercise "
      "${widget.exerciseIndex} ${widget.setIndex}: $result",
    );
  }
}
