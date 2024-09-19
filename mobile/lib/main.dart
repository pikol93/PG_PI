import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/routes.dart';
import 'package:loggy/loggy.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const LoggerPrinter(),
  );

  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'PG PI',
        routerConfig: GoRouter(routes: $appRoutes),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    ),
  );
}
