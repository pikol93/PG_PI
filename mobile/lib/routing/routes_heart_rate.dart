import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/heart_rate/heart_rate_screen.dart";
import "package:pi_mobile/widgets/heart_rate/modify_heart_rate_screen.dart";

part "routes_heart_rate.g.dart";

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
