import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/routes.dart';
import 'package:loggy/loggy.dart';
import 'package:pi_mobile/service/stored_locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoredLocaleService.initialize();
  Loggy.initLoggy(
    logPrinter: const LoggerPrinter(),
  );

  final router = GoRouter(routes: $appRoutes);

  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: App(
          router: router,
        ),
      ),
    ),
  );
}

class App extends ConsumerWidget {
  final GoRouter router;

  const App({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PG PI',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
    );
  }
}
