import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/widgets/sessions/sessions_history/sessions_history_screen.dart";

part "routes_sessions.g.dart";

@TypedGoRoute<SessionsHistoryRoute>(
  path: "/sessions",
)
class SessionsHistoryRoute extends GoRouteData {
  const SessionsHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SessionsHistoryScreen();
}
