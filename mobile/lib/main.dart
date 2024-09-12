import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/routes/logged_in/logged_in_app_route.dart';
import 'package:pi_mobile/screens/exercises_screen.dart';
import 'package:pi_mobile/screens/home_screen.dart';
import 'package:pi_mobile/screens/tracks_screen.dart';
import 'package:pi_mobile/screens/login_screen.dart';
import 'package:pi_mobile/screens/register_screen.dart';
import 'package:pi_mobile/screens/welcome_screen.dart';
import 'package:pi_mobile/service/auth_service.dart';
import 'package:pi_mobile/routes/logged_off/logged_off_app_route.dart';

void main() {
  final authService = AuthService();

  final router = GoRouter(
    routes: [
      GoRoute(
          path: LoggedInAppRoute.home.getName(),
          builder: (context, state) => const HomeScreen(),
          redirect: (context, state) {
            if (authService.isAuthenticated()) {
              // Do not redirect
              return null;
            }

            return LoggedOffAppRoute.welcome.getName();
          }),
      GoRoute(
        path: LoggedInAppRoute.navigation.getName(),
        builder: (context, state) => const TracksScreen(),
      ),
      GoRoute(
        path: LoggedInAppRoute.workout.getName(),
        builder: (context, state) => const ExercisesScreen(),
      ),
      GoRoute(
        path: LoggedInAppRoute.settings.getName(),
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.welcome.getName(),
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.register.getName(),
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: LoggedOffAppRoute.login.getName(),
        builder: (context, state) => const LoginScreen(),
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
