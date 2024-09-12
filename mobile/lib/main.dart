import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/routes/logged_in/logged_in_app_route.dart';
import 'package:pi_mobile/routes/logged_in/exercises_route.dart';
import 'package:pi_mobile/routes/logged_in/home_route.dart';
import 'package:pi_mobile/routes/logged_in/tracks_route.dart';
import 'package:pi_mobile/routes/logged_off/login_route.dart';
import 'package:pi_mobile/routes/logged_off/register_route.dart';
import 'package:pi_mobile/routes/logged_off/welcome_route.dart';
import 'package:pi_mobile/service/auth_service.dart';
import 'package:pi_mobile/routes/logged_off/logged_off_app_route.dart';

void main() {
  final authService = AuthService();

  final router = GoRouter(
    routes: [
      GoRoute(
          path: LoggedInAppRoute.home.getName(),
          builder: (context, state) => const HomeRoute(),
          redirect: (context, state) {
            if (authService.isAuthenticated()) {
              // Do not redirect
              return null;
            }

            return LoggedOffAppRoute.welcome.getName();
          }),
      GoRoute(
        path: LoggedInAppRoute.navigation.getName(),
        builder: (context, state) => const TracksRoute(),
      ),
      GoRoute(
        path: LoggedInAppRoute.workout.getName(),
        builder: (context, state) => const ExercisesRoute(),
      ),
      GoRoute(
        path: LoggedInAppRoute.settings.getName(),
        builder: (context, state) => const HomeRoute(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.welcome.getName(),
        builder: (context, state) => const WelcomeRoute(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.register.getName(),
        builder: (context, state) => const RegisterRoute(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.login.getName(),
        builder: (context, state) => const LoginRoute(),
      ),
    ],
  );

  runApp(
    MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    ),
  );
}
