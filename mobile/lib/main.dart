import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/preferences/development_mode_provider.dart";
import "package:pi_mobile/provider/preferences/package_info_provider.dart";
import "package:pi_mobile/provider/preferences/theme_provider.dart";
import "package:pi_mobile/routing/router.dart";
import "package:pi_mobile/service/stored_locale_service.dart";
import "package:pi_mobile/service/tracks_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoredLocaleService.initialize();
  FlutterForegroundTask.initCommunicationPort();
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

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final void Function(Object data) _onReceiveTaskData;

  @override
  void initState() {
    super.initState();
    _onReceiveTaskData = ref.read(receiveTaskDataProvider).onReceiveTaskData;
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    ref.read(developmentModeProvider.notifier).init();
    ref.read(packageInfoProvider.notifier).init();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
  }

  @override
  Widget build(BuildContext context) => ref.watch(themeProvider).when(
        data: (theme) => MaterialApp.router(
          title: "PG PI",
          routerConfig: ref.watch(routerProvider),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: theme.toThemeMode(),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: AppLocaleUtils.supportedLocales,
          locale: AppLocale.pl.flutterLocale,
        ),
        error: (error, stackTrace) => Center(
          child: Text("An error has occurred. $error\n$stackTrace"),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
}

// The callback function should always be a top-level function.
@pragma("vm:entry-point")
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}
