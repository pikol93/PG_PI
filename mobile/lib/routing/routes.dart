import "dart:async";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/routing/routes_routines.dart";
import "package:pi_mobile/widgets/calendar/calendar_screen.dart";
import "package:pi_mobile/widgets/settings/settings_screen.dart";

part "routes.g.dart";

@TypedGoRoute<SplashRoute>(path: "/")
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      const RoutinesRoute().location;
}

@TypedGoRoute<SettingsRoute>(path: "/settings")
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@TypedGoRoute<CalendarRoute>(path: "/calendar")
class CalendarRoute extends GoRouteData {
  const CalendarRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CalendarScreen();
}
