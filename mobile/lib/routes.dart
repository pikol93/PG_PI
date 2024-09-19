import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/screens/exercises_screen.dart';
import 'package:pi_mobile/screens/home_screen.dart';
import 'package:pi_mobile/screens/login_screen.dart';
import 'package:pi_mobile/screens/register_screen.dart';
import 'package:pi_mobile/screens/settings_screen.dart';
import 'package:pi_mobile/screens/tracks_screen.dart';
import 'package:pi_mobile/screens/welcome_screen.dart';
import 'package:pi_mobile/screens/welcome_settings_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<RootRoute>(path: "/")
class RootRoute extends GoRouteData with Logger {
  const RootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    logger.debug("root route");
    final state =
        await ProviderScope.containerOf(context).read(authProvider.future);

    if (state == null) {
      return const WelcomeRoute().location;
    } else {
      return const HomeRoute().location;
    }
  }
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

@TypedGoRoute<TracksRoute>(path: "/tracks")
class TracksRoute extends GoRouteData with Logger {
  const TracksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("tracks route");
    return const TracksScreen();
  }
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

@TypedGoRoute<WelcomeRoute>(
  path: "/welcome",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<RegisterRoute>(path: "register"),
    TypedGoRoute<LoginRoute>(path: "login"),
    TypedGoRoute<WelcomeSettingsRoute>(path: "settings"),
  ],
)
class WelcomeRoute extends GoRouteData with Logger {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("welcome route");
    return const WelcomeScreen();
  }
}

class RegisterRoute extends GoRouteData with Logger {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("register route");
    return const RegisterScreen();
  }
}

class LoginRoute extends GoRouteData with Logger {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("login route");
    return const LoginScreen();
  }
}

class WelcomeSettingsRoute extends GoRouteData with Logger {
  const WelcomeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("welcome settings route");
    return const WelcomeSettingsScreen();
  }
}
