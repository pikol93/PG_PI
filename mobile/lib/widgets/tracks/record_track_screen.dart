import "dart:async";

import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/main.dart";
import "package:pi_mobile/provider/recorded_track_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class RecordTrackScreen extends ConsumerStatefulWidget {
  const RecordTrackScreen({super.key});

  @override
  ConsumerState<RecordTrackScreen> createState() => _RecordTrackScreenState();
}

class _RecordTrackScreenState extends ConsumerState<RecordTrackScreen>
    with Logger {
  static const serviceId = 257;

  @override
  void initState() {
    super.initState();

    // TODO: Initialize and start the service properly. Handle cases where
    //  starting the service did not work.
    ref.read(recordedTrackProvider.notifier).initialize();
    _initService();
    unawaited(_startService());
  }

  @override
  Widget build(BuildContext context) {
    final track = ref.watch(recordedTrackProvider)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Record track"), // TODO: I18N
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onStopRecordingPressed(context),
        child: const Icon(Icons.stop),
      ),
      body: Column(
        children: [
          Text(track.uuid),
          Expanded(
            child: ListView.builder(
              itemCount: track.locations.length,
              itemBuilder: (context, index) {
                final location = track.locations[index];
                return Text("${location.latitude} ${location.longitude}");
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onStopRecordingPressed(BuildContext context) {
    logger.debug("Stopped recording pressed");
    _stopService();

    // TODO: Navigate to track summary route instead
    const TracksRoute().go(context);
  }

  void _initService() {
    logger.debug("Initializing foreground task.");
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: "foreground_service",
        channelName: "Foreground Service Notification",
        channelDescription:
            "This notification appears when the foreground service is running.",
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        playSound: true,
        showBadge: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        allowWakeLock: true,
        allowWifiLock: true,
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
      ),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    logger.debug("Starting foreground service.");
    final serviceRequestResult = await FlutterForegroundTask.startService(
      serviceId: serviceId,
      notificationTitle: "Foreground Service is running",
      notificationText: "Tap to return to the app",
      callback: startCallback,
    );
    logger.debug("Service request result:"
        " ${serviceRequestResult.success}"
        " ${serviceRequestResult.error}");
    return serviceRequestResult;
  }

  Future<ServiceRequestResult> _stopService() =>
      FlutterForegroundTask.stopService();
}
