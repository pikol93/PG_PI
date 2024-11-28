import "dart:async";
import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/utility/double.dart";
import "package:pi_mobile/utility/duration.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/set/common/exercise_name_header.dart";
import "package:pi_mobile/widgets/routines/bottom_sheet/shown/set/common/set_count_subheader.dart";

class SetRestingPage extends ConsumerWidget with Logger {
  final String exerciseName;
  final ActiveSession activeSession;
  final int exerciseIndex;
  final int setIndex;
  final int setTotalCount;
  final DateTime restStart;
  final DateTime restEnd;

  const SetRestingPage({
    super.key,
    required this.exerciseName,
    required this.activeSession,
    required this.exerciseIndex,
    required this.setIndex,
    required this.setTotalCount,
    required this.restStart,
    required this.restEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExerciseNameHeader(exerciseName: exerciseName),
          SetCountSubheader(
            setIndex: setIndex,
            setTotalCount: setTotalCount,
          ),
          Text(
            context.t.routines.workout.restTime,
            textAlign: TextAlign.center,
            style: context.textStyles.displaySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: _Timer(restStart: restStart, restEnd: restEnd),
            ),
          ),
          ElevatedButton(
            onPressed: () => _onRestDonePressed(ref),
            child: Text(context.t.routines.workout.restDone),
          ),
        ],
      );

  Future<void> _onRestDonePressed(WidgetRef ref) async {
    final result = await ref
        .watch(activeSessionServiceProvider)
        .finishRest(
          setIndex,
        )
        .run();

    logger.debug(
      "Set done pressed for exercise $exerciseIndex $setIndex: $result",
    );
  }
}

class _Timer extends StatefulWidget {
  final DateTime restStart;
  final DateTime restEnd;

  const _Timer({required this.restStart, required this.restEnd});

  @override
  State<StatefulWidget> createState() => _TimerState();
}

class _TimerState extends State<_Timer> with Logger {
  late final Timer timer;
  late final int millisTotal;

  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTimerCallback);
    millisTotal = widget.restEnd.difference(widget.restStart).inMilliseconds;
    currentTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final clampedCurrent = currentTime.clamp(widget.restStart, widget.restEnd);
    final durationLeft = widget.restEnd.difference(clampedCurrent);
    final progressRemaining =
        (durationLeft.inMilliseconds / millisTotal).clamp(0.0, 1.0);
    final minutesSecondsString = progressRemaining.almostEquals(0.0)
        ? context.t.routines.workout.restIsDone
        : durationLeft.toMinutesSeconds();

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scaleX: -1,
          child: CircularProgressIndicator(
            value: progressRemaining,
            strokeWidth: 8.0,
          ),
        ),
        Center(
          child: Text(
            minutesSecondsString,
            style: context.textStyles.displayMedium,
          ),
        ),
      ],
    );
  }

  void _onTimerCallback(Timer timer) {
    currentTime = DateTime.now();
    setState(() {});
  }
}
