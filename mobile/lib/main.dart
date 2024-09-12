import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/app_route.dart';
import 'package:pi_mobile/routes/exercises_route.dart';
import 'package:pi_mobile/routes/home_route.dart';
import 'package:pi_mobile/routes/tracks_route.dart';

void main() {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoute.home.getName(),
        builder: (context, state) => const HomeRoute(),
      ),
      GoRoute(
        path: AppRoute.navigation.getName(),
        builder: (context, state) => const TracksRoute(),
      ),
      GoRoute(
        path: AppRoute.workout.getName(),
        builder: (context, state) => const ExercisesRoute(),
      ),
      GoRoute(
        path: AppRoute.settings.getName(),
        builder: (context, state) => const HomeRoute(),
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
