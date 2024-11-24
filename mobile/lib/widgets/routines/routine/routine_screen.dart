import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/routine.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";
import "package:pi_mobile/widgets/routines/routine/sections/exercise_one_rep_max_section.dart";
import "package:pi_mobile/widgets/routines/routine/sections/title_section.dart";
import "package:pi_mobile/widgets/routines/routine/sections/workouts_section.dart";

class RoutineScreen extends ConsumerWidget {
  final int routineId;

  const RoutineScreen({super.key, required this.routineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(routinesMapProvider).whenDataOrEmptyScaffold(
            context,
            (routinesMap) => AppScaffold(
              appBar: AppBar(
                title: Text(context.t.routines.routine.title),
              ),
              body: routinesMap
                  .get(routineId)
                  .map((routine) => _Routine(routine: routine) as Widget)
                  .getOrElse(_NoRoutine.new),
            ),
          );
}

class _NoRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(
        child: Text("No routine"), // TODO: I18N
      );
}

class _Routine extends StatelessWidget {
  final Routine routine;

  const _Routine({required this.routine});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            RoutineTitleSection(routine: routine),
            RoutineExerciseOneRepMaxSection(routine: routine),
            RoutineWorkoutsSection(routine: routine),
          ],
        ),
      );
}
