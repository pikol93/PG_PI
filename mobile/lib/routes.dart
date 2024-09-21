import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/screens/exercises_screen.dart';
import 'package:pi_mobile/screens/home_screen.dart';
import 'package:pi_mobile/screens/login_screen.dart';
import 'package:pi_mobile/screens/register_screen.dart';
import 'package:pi_mobile/screens/settings_screen.dart';
import 'package:pi_mobile/screens/tracks_screen.dart';
import 'package:pi_mobile/screens/welcome_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<RootRoute>(path: "/")
class RootRoute extends GoRouteData {
  const RootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    print("root route");
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
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("home route");
    return const HomeScreen();
  }
}

@TypedGoRoute<TracksRoute>(path: "/tracks")
class TracksRoute extends GoRouteData {
  const TracksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("tracks route");
    return const TracksScreen();
  }
}

@TypedGoRoute<ExercisesRoute>(path: "/exercises")
class ExercisesRoute extends GoRouteData {
  const ExercisesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("exercises route");
    return ExercisesScreen();
  }
}

@TypedGoRoute<SettingsRoute>(path: "/settings")
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("settings route");
    return const SettingsScreen();
  }
}

@TypedGoRoute<WelcomeRoute>(
  path: "/welcome",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<RegisterRoute>(path: "register"),
    TypedGoRoute<LoginRoute>(path: "login"),
  ],
)
class WelcomeRoute extends GoRouteData {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("welcome route");
    return const WelcomeScreen();
  }
}

class RegisterRoute extends GoRouteData {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("register route");
    return const RegisterScreen();
  }
}

class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print("login route");
    return const LoginScreen();
  }
}
