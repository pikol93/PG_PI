import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/routes.dart';

void main() {
  runApp(
    MaterialApp.router(
      title: 'PG PI',
      routerConfig: GoRouter(routes: $appRoutes),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    ),
  );
}
