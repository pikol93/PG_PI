import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/logger.dart";
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
class ExercisesRoute extends GoRouteData with Logger {
  const ExercisesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("exercises route");
    return const ExercisesScreen();
  }
}

class HistoryRoute extends GoRouteData with Logger {
  const HistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("history route");
    return const HistoryScreen();
  }
}

class HistoryRecordRoute extends GoRouteData with Logger {
  const HistoryRecordRoute({required this.trainingUuid});

  final String trainingUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("history record route");
    return HistoryRecordScreen(trainingUuid: trainingUuid);
  }
}

class RoutinesRoute extends GoRouteData with Logger {
  const RoutinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("routines route");
    return const RoutinesScreen();
  }
}

class EditRoutineSchemaRoute extends GoRouteData with Logger {
  const EditRoutineSchemaRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("routines route");
    return EditRoutineSchemaScreen(routineUuid: routineUuid);
  }
}

class EditWorkoutSchemaRoute extends GoRouteData with Logger {
  const EditWorkoutSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
  });

  final String routineUuid;
  final String workoutUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditWorkoutSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
    );
  }
}

class EditExerciseSchemaRoute extends GoRouteData with Logger {
  const EditExerciseSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
  });

  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditExerciseSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
    );
  }
}

class EditExerciseSetSchemaRoute extends GoRouteData with Logger {
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
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditExerciseSetSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
      exerciseSetUuid: exerciseSetUuid,
    );
  }
}

class OpenRoutineTrainingRoute extends GoRouteData with Logger {
  const OpenRoutineTrainingRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("execute routines route");
    return RoutineTrainingScreen(routineUuid: routineUuid);
  }
}

class OpenWorkoutTrainingRoute extends GoRouteData with Logger {
  const OpenWorkoutTrainingRoute({
    required this.routineUuid,
    required this.trainingUuid,
  });

  final String routineUuid;
  final String trainingUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("execute workouts route");
    return WorkoutTrainingScreen(
      routineUuid: routineUuid,
      trainingUuid: trainingUuid,
    );
  }
}

class OpenExerciseTrainingRoute extends GoRouteData with Logger {
  const OpenExerciseTrainingRoute({
    required this.routineUuid,
    required this.trainingUuid,
    required this.exerciseUuid,
  });

  final String routineUuid;
  final String trainingUuid;
  final String exerciseUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("execute exercise route");
    return ExerciseTrainingScreen(
      routineUuid: routineUuid,
      trainingUuid: trainingUuid,
      exerciseUuid: exerciseUuid,
    );
  }
}

class OpenExerciseSetTrainingRoute extends GoRouteData with Logger {
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
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("execute exercise set route");
    return ExerciseSetTrainingScreen(
      routineUuid: routineUuid,
      trainingUuid: trainingUuid,
      exerciseUuid: exerciseUuid,
      exerciseSetUuid: exerciseSetUuid,
    );
  }
}
