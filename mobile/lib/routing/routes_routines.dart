import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/routines/all_routines/routines_screen.dart";
import "package:pi_mobile/widgets/routines/routine/routine_screen.dart";

part "routes_routines.g.dart";

@TypedGoRoute<RoutinesRoute>(
  path: "/routines",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<RoutineRoute>(path: ":routineId"),
  ],
)
class RoutinesRoute extends GoRouteData {
  const RoutinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RoutinesScreen();
}

class RoutineRoute extends GoRouteData {
  final int routineId;

  RoutineRoute({required this.routineId});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RoutineScreen(routineId: routineId);
}
