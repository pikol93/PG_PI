import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/calendar/calendar_screen.dart";
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
import "package:pi_mobile/widgets/heart_rate/heart_rate_screen.dart";
import "package:pi_mobile/widgets/heart_rate/modify_heart_rate_screen.dart";
import "package:pi_mobile/widgets/home/home_screen.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_details_screen.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_modify_one_rep_max_screen.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_modify_specific_one_rep_max_screen.dart";
import "package:pi_mobile/widgets/new_exercises/exercises_screen.dart";
import "package:pi_mobile/widgets/settings/settings_screen.dart";

part "routes.g.dart";

@TypedGoRoute<SplashRoute>(path: "/")
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      const HomeRoute().location;
}

@TypedGoRoute<HomeRoute>(path: "/home")
class HomeRoute extends GoRouteData with Logger {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("home route");
    return const HomeScreen();
  }
}

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

@TypedGoRoute<HeartRateRoute>(
  path: "/heart_rate",
  routes: <TypedGoRoute>[
    TypedGoRoute<AddHeartRateRoute>(path: "add"),
    TypedGoRoute<ModifyHeartRateRoute>(path: "modify/:entryId"),
  ],
)
class HeartRateRoute extends GoRouteData {
  const HeartRateRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HeartRateScreen();
}

class AddHeartRateRoute extends GoRouteData {
  const AddHeartRateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ModifyHeartRateScreen();
}

class ModifyHeartRateRoute extends GoRouteData {
  final int entryId;

  const ModifyHeartRateRoute({
    required this.entryId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ModifyHeartRateScreen(
        entryId: entryId,
      );
}

@TypedGoRoute<SettingsRoute>(path: "/settings")
class SettingsRoute extends GoRouteData with Logger {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("settings route");
    return const SettingsScreen();
  }
}

@TypedGoRoute<CalendarRoute>(path: "/calendar")
class CalendarRoute extends GoRouteData with Logger {
  const CalendarRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CalendarScreen();
}

@TypedGoRoute<ExercisesScreenARoute>(
  path: "/exercises_a",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ExerciseDetailsRoute>(
      path: ":exerciseId",
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ExerciseModifyOneRepMaxRoute>(
          path: "modify",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<ExerciseAddSpecificOneRepMaxRoute>(
              path: "new",
            ),
            TypedGoRoute<ExerciseModifySpecificOneRepMaxRoute>(
              path: "modify/:dateTimestamp",
            ),
          ],
        ),
      ],
    ),
  ],
)
class ExercisesScreenARoute extends GoRouteData {
  const ExercisesScreenARoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExercisesScreenA();
}

class ExerciseDetailsRoute extends GoRouteData {
  final int exerciseId;

  const ExerciseDetailsRoute({
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseDetailsScreen(exerciseId: exerciseId);
}

class ExerciseModifyOneRepMaxRoute extends GoRouteData {
  final int exerciseId;

  const ExerciseModifyOneRepMaxRoute({
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseModifyOneRepMaxScreen(exerciseId: exerciseId);
}

class ExerciseAddSpecificOneRepMaxRoute extends GoRouteData {
  final int exerciseId;

  const ExerciseAddSpecificOneRepMaxRoute({
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseModifySpecificOneRepMaxScreen(
        exerciseId: exerciseId,
      );
}

class ExerciseModifySpecificOneRepMaxRoute extends GoRouteData {
  final int exerciseId;
  final int dateTimestamp;

  const ExerciseModifySpecificOneRepMaxRoute({
    required this.exerciseId,
    required this.dateTimestamp,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseModifySpecificOneRepMaxScreen(
        exerciseId: exerciseId,
        date: DateTime.fromMillisecondsSinceEpoch(dateTimestamp),
      );
}
