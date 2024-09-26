import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/provider/theme_provider.dart';
import 'package:pi_mobile/routing/router.dart';
import 'package:loggy/loggy.dart';
import 'package:pi_mobile/service/stored_locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoredLocaleService.initialize();
  Loggy.initLoggy(
    logPrinter: const LoggerPrinter(),
  );

  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const App(),
      ),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(themeProvider).when(
          data: (theme) => MaterialApp.router(
            title: 'PG PI',
            routerConfig: ref.watch(routerProvider),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: theme.toThemeMode(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocaleUtils.supportedLocales,
          ),
          error: (error, stackTrace) => Center(
            child: Text("An error has occurred. $error\n$stackTrace"),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
