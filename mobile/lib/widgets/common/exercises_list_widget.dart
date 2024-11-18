import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/schemas_provider.dart";
import "package:pi_mobile/routing/routes_old_exercises.dart";

class ExercisesListWidget extends ConsumerStatefulWidget {
  final String routineUuid;
  final String workoutUuid;
  final List<StrengthExerciseSchema> exercises;

  const ExercisesListWidget({
    super.key,
    required this.exercises,
    required this.routineUuid,
    required this.workoutUuid,
  });

  @override
  ConsumerState<ExercisesListWidget> createState() => _ExercisesListWidget();
}

class _ExercisesListWidget extends ConsumerState<ExercisesListWidget> {
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(
                    "${context.t.routines.amountOfSets}: "
                    "${exercise.sets.length}",
                  ),
                  onTap: () {
                    _onTap(
                      context,
                      widget.routineUuid,
                      widget.workoutUuid,
                      exercise.uuid,
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _onDeleteButtonPressed(context, exercise),
              ),
            ],
          );
        },
      );

  void _onTap(
    BuildContext context,
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
  ) {
    EditExerciseSchemaRoute(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
    ).go(context);
  }

  Future<void> _onDeleteButtonPressed(
    BuildContext context,
    StrengthExerciseSchema exercise,
  ) async {
    await ref
        .read(schemasProvider.notifier)
        .deleteExercise(widget.routineUuid, widget.workoutUuid, exercise.uuid);
  }
}
