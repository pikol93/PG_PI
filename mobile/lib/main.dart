import "dart:io";

import "package:fl_location/fl_location.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/theme_provider.dart";
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

  // TODO: Move this somewhere else.
  // Request permissions and initialize the service.
  await _requestPermissions();

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

Future<void> _requestPermissions() async {
  // Android 13+, you need to allow notification permission to display
  // foreground service notification.
  //
  // iOS: If you need notification, ask for permission.
  final notificationPermission =
      await FlutterForegroundTask.checkNotificationPermission();
  logDebug("Notification permission: $notificationPermission");
  if (notificationPermission != NotificationPermission.granted) {
    await FlutterForegroundTask.requestNotificationPermission();
  }

  if (Platform.isAndroid) {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW`
      // permission.
      logDebug("Cannot draw overlays. Opening system alert window settings.");
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12+, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need
    // to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires
      // `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      logDebug(
        "Is not ignoring battery optimizations."
        " Opening ignore battery optimizations settings.",
      );
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }

  final locationPermissions = await FlLocation.checkLocationPermission();
  logDebug("location permissions: $locationPermissions");
  if (locationPermissions == LocationPermission.denied ||
      locationPermissions == LocationPermission.deniedForever) {
    final locationPermissionsAfterRequesting =
        await FlLocation.requestLocationPermission();
    logDebug("permissions after request: $locationPermissionsAfterRequesting");
  }
}

// The callback function should always be a top-level function.
@pragma("vm:entry-point")
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}
