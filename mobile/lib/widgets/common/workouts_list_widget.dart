import "package:flutter/material.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/routing/routes.dart";

class WorkoutsListWidget extends StatelessWidget {
  final String routineUuid;
  final List<WorkoutSchema> workouts;

  const WorkoutsListWidget({
    super.key,
    required this.workouts,
    required this.routineUuid,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            title: Text(workout.name),
            subtitle: Text(workout.uuid),
            onTap: () {
              _onTap(context, routineUuid, workout.uuid);
            },
          );
        },
      );

  void _onTap(BuildContext context, String routineUuid, String workoutUuid) {
    EditWorkoutSchemaRoute(routineUuid: routineUuid, workoutUuid: workoutUuid)
        .go(context);
  }
}
