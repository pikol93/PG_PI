import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/calendar/calendar_screen.dart";
import "package:pi_mobile/widgets/home/home_screen.dart";
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
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
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
