import "package:flutter/material.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/routing/routes.dart";

class ExercisesListWidget extends StatelessWidget {
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
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text("${exercise.uuid}  ${exercise.sets.length}"),
            onTap: () {
              _onTap(context, routineUuid, workoutUuid, exercise.uuid);
            },
          );
        },
      );

  void _onTap(BuildContext context, String routineUuid, String workoutUuid,
      String exerciseUuid,) {
    EditExerciseSchemaRoute(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
    ).go(context);
  }
}
