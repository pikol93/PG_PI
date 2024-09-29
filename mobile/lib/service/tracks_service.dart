import "dart:async";
import "dart:convert";

import "package:fl_location/fl_location.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/data/location.dart" as internal;
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";

class LocationTaskHandler extends TaskHandler with Logger {
  StreamSubscription<Location>? _streamSubscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // This handler can be thought of as a separate process than the main
    // application. This causes a need for separate initialization process.
    Loggy.initLoggy(logPrinter: const LoggerPrinter());

    logger.debug("onStart $timestamp");
    _streamSubscription = FlLocation.getLocationStream().listen(_onLocation);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    logger.debug("onDestroy $timestamp");
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    logger.debug("onRepeatEvent $timestamp");
  }

  @override
  void onNotificationPressed() {
    logger.debug("onNotificationPressed");
    FlutterForegroundTask.launchApp(const RecordTrackRoute().location);
  }

  void _onLocation(Location location) {
    logger.debug(
      "Status:"
      " ${location.millisecondsSinceEpoch},"
      " ${location.longitude},"
      " ${location.latitude}",
    );

    final internalLocation = internal.Location(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        location.millisecondsSinceEpoch.toInt(),
      ),
      longitude: location.longitude,
      latitude: location.latitude,
    );

    final json = jsonEncode(internalLocation);
    FlutterForegroundTask.sendDataToMain(json);
  }
}

final receiveTaskDataProvider = Provider(
  (ref) => ReceiveTaskDataProcessor(
    ref: ref,
  ),
);

class ReceiveTaskDataProcessor with Logger {
  final Ref ref;

  ReceiveTaskDataProcessor({required this.ref});

  void onReceiveTaskData(Object data) {
    logger.debug("onReceiveTaskData: $data");
  }
}
