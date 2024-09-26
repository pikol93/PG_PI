import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/routing/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "router.g.dart";

@riverpod
GoRouter router(RouterRef ref) {
  final routerKey = GlobalKey<NavigatorState>(debugLabel: "routerKey");
  final isAuth = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());
  ref
    ..onDispose(isAuth.dispose)
    ..listen(
      authProvider.select(
        (value) => value.whenData((value) => value != null),
      ),
      (_, next) {
        isAuth.value = next;
      },
    );

  final router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: routerKey,
      refreshListenable: isAuth,
      initialLocation: const SplashRoute().location,
      routes: $appRoutes,
      redirect: (context, state) {
        logDebug("Redirect: ${state.uri.path}");
        if (isAuth.value.unwrapPrevious().hasError) {
          logDebug("Authorization value could not be fetched.");
          return const LoginRoute().location;
        }

        if (isAuth.value.isLoading || !isAuth.value.hasValue) {
          logDebug("Authorization value is loading or does not have a value.");
          return null;
        }

        final isAuthorized = isAuth.value.requireValue;
        final currentRouteAuthorizationType =
            getAuthorizationTypeFromPath(state.uri.path);
        if (currentRouteAuthorizationType == null) {
          return null;
        }

        switch (currentRouteAuthorizationType) {
          case RouteAuthorizationType.noAuthorization:
            if (isAuthorized) {
              logDebug(
                  "Redirecting. Is authorized and current route does not require authorization.");
              return const HomeRoute().location;
            }
          case RouteAuthorizationType.requiresAuthorization:
            if (!isAuthorized) {
              logDebug(
                  "Redirecting. Is not authorized and current route requires authorization.");
              return const LoginRoute().location;
            }
          case RouteAuthorizationType.redirect:
            return isAuthorized
                ? const HomeRoute().location
                : const LoginRoute().location;
        }

        return null;
      });

  ref.onDispose(router.dispose);

  return router;
}
