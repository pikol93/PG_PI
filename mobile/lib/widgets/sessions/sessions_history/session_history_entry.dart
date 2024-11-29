import "dart:core";

import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart" as fpdart;
import "package:pi_mobile/data/exercise/exercise_model.dart";
import "package:pi_mobile/data/exercise/exercise_models_provider.dart";
import "package:pi_mobile/data/preferences/date_formatter_provider.dart";
import "package:pi_mobile/data/routine/routines_provider.dart";
import "package:pi_mobile/data/session/session.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/option.dart";
import "package:pi_mobile/widgets/common/exercise_icon.dart";
import "package:pi_mobile/widgets/routines/common/section_content.dart";
import "package:pi_mobile/widgets/sessions/common/share_notifier.dart";
import "package:pi_mobile/widgets/sessions/common/subsection.dart";

class SessionHistoryEntry extends ConsumerWidget {
  final ShareNotifier shareNotifier;
  final Session session;

  const SessionHistoryEntry({
    super.key,
    required this.shareNotifier,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SectionContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateHeader(
              shareNotifier: shareNotifier,
              sessionId: session.id,
              date: session.startDate,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SubsectionRoutineName(routineId: session.routineId),
                _SubsectionWorkoutName(
                  routineId: session.routineId,
                  workoutId: session.workoutId,
                ),
                _SubsectionExercises(exercises: session.exercises),
              ],
            ),
          ],
        ),
      );
}

class _DateHeader extends ConsumerWidget with Logger {
  final ShareNotifier shareNotifier;
  final int sessionId;
  final DateTime date;

  const _DateHeader({
    required this.shareNotifier,
    required this.sessionId,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ref.watch(dateFormatterProvider).fullDate(date),
            style: context.textStyles.titleLarge,
          ),
          ListenableBuilder(
            listenable: shareNotifier,
            builder: (context, _) => Checkbox(
              value: shareNotifier.isPressed(sessionId),
              onChanged: _onShareCheckboxChanged,
            ),
          ),
        ],
      );

  void _onShareCheckboxChanged(bool? value) {
    logger.debug("Checkbox changed for session $sessionId: $value");
    shareNotifier.set(sessionId, value ?? false);
  }
}

class _SubsectionRoutineName extends ConsumerWidget {
  final int routineId;

  const _SubsectionRoutineName({required this.routineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Subsection(
        subsectionTitle: context.t.sessions.history.routineName,
        subsectionBody: Text(
          ref
              .watch(routinesMapProvider)
              .toOption()
              .map(
                (map) => map.get(routineId).map((routine) => routine.name),
              )
              .flatten()
              .orElse(context.t.sessions.history.unknownRoutine),
        ),
      );
}

class _SubsectionWorkoutName extends ConsumerWidget {
  final int routineId;
  final int workoutId;

  const _SubsectionWorkoutName({
    required this.routineId,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Subsection(
        subsectionTitle: context.t.sessions.history.workoutName,
        subsectionBody: Text(
          ref
              .watch(routinesMapProvider)
              .toOption()
              .map(
                (routinesMap) => routinesMap
                    .get(routineId)
                    .map(
                      (routine) => routine.workouts
                          .where((workout) => workout.id == workoutId)
                          .firstOption
                          .map((workout) => workout.name),
                    )
                    .flatten(),
              )
              .flatten()
              .orElse(context.t.sessions.history.unknownWorkout),
        ),
      );
}

class _SubsectionExercises extends ConsumerWidget {
  static const _columnWidths = {
    0: IntrinsicColumnWidth(),
    2: IntrinsicColumnWidth(),
  };

  final List<SessionExercise> exercises;

  const _SubsectionExercises({required this.exercises});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Subsection(
        subsectionTitle: context.t.sessions.history.exercises,
        subsectionBody: Table(
          columnWidths: _columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: exercises
              .map(
                (exercise) => _buildRow(
                  context,
                  exercise,
                  ref
                      .watch(exerciseModelsMapProvider)
                      .toOption()
                      .orElse(const {}),
                ),
              )
              .toList(),
        ),
      );

  TableRow _buildRow(
    BuildContext context,
    SessionExercise exercise,
    Map<int, ExerciseModel> exerciseMap,
  ) =>
      TableRow(
        children: [
          const ExerciseIcon(size: 24),
          Text(
            exerciseMap
                .get(exercise.exerciseId)
                .map((model) => model.name)
                .orElse(context.t.sessions.history.unknownExercise),
          ),
          Text("${exercise.sets.length} sets"),
        ],
      );
}
