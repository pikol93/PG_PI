import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/exercise_model.dart";
import "package:pi_mobile/data/routine/routine.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/widgets/routines/common/section_content.dart";
import "package:pi_mobile/widgets/routines/common/section_header.dart";

class RoutineWorkoutsSection extends StatelessWidget {
  final Routine routine;

  const RoutineWorkoutsSection({super.key, required this.routine});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title: context.t.routines.routine.section.workouts),
            _SectionInternal(routine: routine),
          ],
        ),
      );
}

class _SectionInternal extends ConsumerWidget {
  final Routine routine;

  const _SectionInternal({required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(exerciseModelsMapProvider).whenDataOrDefault(
            context,
            (exerciseMap) => Column(
              children: routine.workouts
                  .map(
                    (workout) => _WorkoutWidget(
                      exerciseMap: exerciseMap,
                      workout: workout,
                    ),
                  )
                  .toList(),
            ),
          );
}

class _WorkoutWidget extends StatelessWidget with Logger {
  final Map<int, ExerciseModel> exerciseMap;
  final Workout workout;

  const _WorkoutWidget({required this.exerciseMap, required this.workout});

  @override
  Widget build(BuildContext context) => SectionContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    workout.name,
                    style: context.textStyles.headlineSmall,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onViewPressed,
                  child: const Text("View"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                children: workout.exercises
                    .map(
                      (exercise) => _buildRowForExercise(context, exercise),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );

  TableRow _buildRowForExercise(
    BuildContext context,
    WorkoutExercise exercise,
  ) {
    final exerciseName = exerciseMap
        .get(exercise.exerciseId)
        .map((exercise) => exercise.name)
        .getOrElse(() => "Unknown exercise");

    return TableRow(
      children: [
        const Icon(Icons.fitness_center),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            exerciseName,
            style: context.textStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          "${exercise.sets.length} sets",
          style: context.textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onViewPressed() {
    logger.debug("View button pressed for workout ${workout.name}");
  }
}
