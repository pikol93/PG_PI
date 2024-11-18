import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/routing/routes.dart" as base;
import "package:pi_mobile/routing/routes_exercises.dart" as exercises;
import "package:pi_mobile/routing/routes_heart_rate.dart" as heart_rate;
import "package:pi_mobile/routing/routes_old_exercises.dart" as old_exercises;
import "package:pi_mobile/routing/routes_tracks.dart" as tracks;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "router.g.dart";

@riverpod
GoRouter router(Ref ref) {
  final routerKey = GlobalKey<NavigatorState>(debugLabel: "routerKey");

  final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: routerKey,
    initialLocation: const base.SplashRoute().location,
    routes: [
      ...base.$appRoutes,
      ...exercises.$appRoutes,
      ...heart_rate.$appRoutes,
      ...tracks.$appRoutes,
      ...old_exercises.$appRoutes,
    ],
  );

  ref.onDispose(router.dispose);

  return router;
}
