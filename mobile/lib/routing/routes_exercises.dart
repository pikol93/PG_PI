import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_details_screen.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_modify_one_rep_max_screen.dart";
import "package:pi_mobile/widgets/new_exercises/details/exercise_modify_specific_one_rep_max_screen.dart";
import "package:pi_mobile/widgets/new_exercises/exercises_screen.dart";

part "routes_exercises.g.dart";

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
