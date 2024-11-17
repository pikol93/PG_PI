import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/exercises/exercises_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_exercise_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_exercise_set_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_routine_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_workout_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/history/history_record_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/history/history_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/routines_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/train/exercise_set_training_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/train/exercise_training_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/train/routine_training_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/train/workout_training_screen.dart";

part "routes_old_exercises.g.dart";

@TypedGoRoute<ExercisesRoute>(
  path: "/exercises",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HistoryRoute>(
      path: "history",
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<HistoryRecordRoute>(
          path: ":trainingUuid",
        ),
      ],
    ),
    TypedGoRoute<RoutinesRoute>(
      path: "routines",
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<EditRoutineSchemaRoute>(
          path: "edit/:routineUuid",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<EditWorkoutSchemaRoute>(
              path: ":workoutUuid",
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<EditExerciseSchemaRoute>(
                  path: ":exerciseUuid",
                  routes: <TypedGoRoute<GoRouteData>>[
                    TypedGoRoute<EditExerciseSetSchemaRoute>(
                      path: "exerciseSetUuid",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        TypedGoRoute<OpenRoutineTrainingRoute>(
          path: ":routineUuid",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<OpenWorkoutTrainingRoute>(
              path: ":trainingUuid",
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<OpenExerciseTrainingRoute>(
                  path: ":exerciseUuid",
                  routes: <TypedGoRoute<GoRouteData>>[
                    TypedGoRoute<OpenExerciseSetTrainingRoute>(
                      path: ":exerciseSetUuid",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)
class ExercisesRoute extends GoRouteData {
  const ExercisesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExercisesScreen();
}

class HistoryRoute extends GoRouteData {
  const HistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HistoryScreen();
}

class HistoryRecordRoute extends GoRouteData {
  const HistoryRecordRoute({required this.trainingUuid});

  final String trainingUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HistoryRecordScreen(trainingUuid: trainingUuid);
}

class RoutinesRoute extends GoRouteData {
  const RoutinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RoutinesScreen();
}

class EditRoutineSchemaRoute extends GoRouteData {
  const EditRoutineSchemaRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditRoutineSchemaScreen(routineUuid: routineUuid);
}

class EditWorkoutSchemaRoute extends GoRouteData {
  const EditWorkoutSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
  });

  final String routineUuid;
  final String workoutUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditWorkoutSchemaScreen(
        routineUuid: routineUuid,
        workoutUuid: workoutUuid,
      );
}

class EditExerciseSchemaRoute extends GoRouteData {
  const EditExerciseSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
  });

  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditExerciseSchemaScreen(
        routineUuid: routineUuid,
        workoutUuid: workoutUuid,
        exerciseUuid: exerciseUuid,
      );
}

class EditExerciseSetSchemaRoute extends GoRouteData {
  const EditExerciseSetSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
    required this.exerciseSetUuid,
  });

  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;
  final String exerciseSetUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditExerciseSetSchemaScreen(
        routineUuid: routineUuid,
        workoutUuid: workoutUuid,
        exerciseUuid: exerciseUuid,
        exerciseSetUuid: exerciseSetUuid,
      );
}

class OpenRoutineTrainingRoute extends GoRouteData {
  const OpenRoutineTrainingRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RoutineTrainingScreen(routineUuid: routineUuid);
}

class OpenWorkoutTrainingRoute extends GoRouteData {
  const OpenWorkoutTrainingRoute({
    required this.routineUuid,
    required this.trainingUuid,
  });

  final String routineUuid;
  final String trainingUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      WorkoutTrainingScreen(
        routineUuid: routineUuid,
        trainingUuid: trainingUuid,
      );
}

class OpenExerciseTrainingRoute extends GoRouteData {
  const OpenExerciseTrainingRoute({
    required this.routineUuid,
    required this.trainingUuid,
    required this.exerciseUuid,
  });

  final String routineUuid;
  final String trainingUuid;
  final String exerciseUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseTrainingScreen(
        routineUuid: routineUuid,
        trainingUuid: trainingUuid,
        exerciseUuid: exerciseUuid,
      );
}

class OpenExerciseSetTrainingRoute extends GoRouteData {
  const OpenExerciseSetTrainingRoute({
    required this.routineUuid,
    required this.trainingUuid,
    required this.exerciseUuid,
    required this.exerciseSetUuid,
  });

  final String routineUuid;
  final String trainingUuid;
  final String exerciseUuid;
  final String exerciseSetUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseSetTrainingScreen(
        routineUuid: routineUuid,
        trainingUuid: trainingUuid,
        exerciseUuid: exerciseUuid,
        exerciseSetUuid: exerciseSetUuid,
      );
}
