import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/location_permissions_provider.dart";
import "package:pi_mobile/provider/notification_permissions_provider.dart";
import "package:pi_mobile/utility/location_permission.dart";
import "package:pi_mobile/utility/notification_permission.dart";
import "package:pi_mobile/widgets/exercises/exercises_screen.dart";
import "package:pi_mobile/widgets/forgot_password/forgot_password_screen.dart";
import "package:pi_mobile/widgets/home/home_screen.dart";
import "package:pi_mobile/widgets/login/login_screen.dart";
import "package:pi_mobile/widgets/register/register_screen.dart";
import "package:pi_mobile/widgets/settings/settings_screen.dart";
import "package:pi_mobile/widgets/settings/welcome_settings_screen.dart";
import "package:pi_mobile/widgets/splash/splash_screen.dart";
import "package:pi_mobile/widgets/tracks/record_track_screen.dart";
import "package:pi_mobile/widgets/tracks/request_location_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/request_notification_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/tracks_screen.dart";

part "routes.g.dart";

final _routesNotRequiringAuthentication = [
  const LoginRoute().location,
  const RegisterRoute().location,
  const WelcomeSettingsRoute().location,
];

final _routesRequiringAuthentication = [
  const HomeRoute().location,
  const TracksRoute().location,
  const ExercisesRoute().location,
  const SettingsRoute().location,
];

final _routesRedirections = [
  const SplashRoute().location,
];

enum RouteAuthorizationType {
  noAuthorization,
  requiresAuthorization,
  redirect,
}

RouteAuthorizationType? getAuthorizationTypeFromPath(String uri) {
  if (_routesRequiringAuthentication.contains(uri)) {
    return RouteAuthorizationType.requiresAuthorization;
  }

  if (_routesNotRequiringAuthentication.contains(uri)) {
    return RouteAuthorizationType.noAuthorization;
  }

  if (_routesRedirections.contains(uri)) {
    return RouteAuthorizationType.redirect;
  }

  return null;
}

@TypedGoRoute<SplashRoute>(path: "/")
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
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

@TypedGoRoute<TracksRoute>(
  path: "/tracks",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<RecordTrackRoute>(path: "record"),
    TypedGoRoute<RequestLocationPermissionRoute>(
      path: "request_permission_location",
    ),
    TypedGoRoute<RequestNotificationPermissionRoute>(
      path: "request_permission_notification",
    ),
  ],
)
class TracksRoute extends GoRouteData with Logger {
  const TracksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("tracks route");
    return const TracksScreen();
  }
}

class RecordTrackRoute extends GoRouteData {
  const RecordTrackRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final providerContainer = ProviderScope.containerOf(context);

    final locationPermission =
        await providerContainer.read(locationPermissionsProvider.future);
    if (locationPermission.isFailure) {
      return const RequestLocationPermissionRoute().location;
    }

    final notificationPermission =
        await providerContainer.read(notificationPermissionsProvider.future);
    if (notificationPermission.isFailure) {
      return const RequestNotificationPermissionRoute().location;
    }

    return null;
  }

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RecordTrackScreen();
}

class RequestLocationPermissionRoute extends GoRouteData {
  const RequestLocationPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestLocationPermissionScreen();
}

class RequestNotificationPermissionRoute extends GoRouteData {
  const RequestNotificationPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestNotificationPermissionScreen();
}

@TypedGoRoute<ExercisesRoute>(path: "/exercises")
class ExercisesRoute extends GoRouteData with Logger {
  const ExercisesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("exercises route");
    return const ExercisesScreen();
  }
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

@TypedGoRoute<RegisterRoute>(path: "/register")
class RegisterRoute extends GoRouteData with Logger {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("register route");
    return const RegisterScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: "/login")
class LoginRoute extends GoRouteData with Logger {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("login route");
    return const LoginScreen();
  }
}

@TypedGoRoute<WelcomeSettingsRoute>(path: "/welcome_settings")
class WelcomeSettingsRoute extends GoRouteData with Logger {
  const WelcomeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("welcome settings route");
    return const WelcomeSettingsScreen();
  }
}

@TypedGoRoute<ForgotPasswordRoute>(path: "/forgot_password")
class ForgotPasswordRoute extends GoRouteData with Logger {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}
