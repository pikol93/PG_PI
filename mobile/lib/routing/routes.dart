import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/calendar/calendar_screen.dart";
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
