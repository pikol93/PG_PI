import "dart:async";

import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/main.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/processed_recorded_track_provider.dart";
import "package:pi_mobile/provider/recorded_track_provider.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:pi_mobile/routing/routes_tracks.dart";
import "package:pi_mobile/widgets/tracks/record_track_bottom_sheet.dart";

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
    ref.read(recordedTrackProvider.notifier).initializeIfNotInitialized();
    _initService();

    final translations = ref.read(currentLocaleProvider).translations;
    unawaited(
      _startService(
        translations.tracks.service.notification.title,
        translations.tracks.service.notification.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final processedTrack = ref.watch(processedRecordedTrackProvider);
    if (processedTrack == null) {
      logger.debug("No data.");
      return const Text("no data.");
    }
    final track = processedTrack.track;
    final velocities = processedTrack.velocities;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Record track"), // TODO: I18N
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onStopRecordingPressed(context, track),
        child: const Icon(Icons.stop),
      ),
      bottomSheet: const RecordTrackBottomSheet(),
      body: Column(
        children: [
          Text("${track.id}"),
          Text("Average velocity: ${processedTrack.averageVelocity}"),
          Expanded(
            child: ListView.builder(
              itemCount: track.locations.length,
              itemBuilder: (context, index) {
                final location = track.locations[index];
                return Text(
                  "${location.latitude}"
                  " ${location.longitude}"
                  " ${location.dateTime}",
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: velocities.length,
              itemBuilder: (context, index) {
                final velocity = velocities[index];
                return Text("$velocity");
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onStopRecordingPressed(
    BuildContext context,
    Track track,
  ) async {
    logger.debug("Stopped recording pressed");
    unawaited(_stopService());

    ref.read(recordedTrackProvider.notifier).clear();
    final manager = await ref.read(tracksManagerProvider.future);
    final id = await manager.save(track);

    if (context.mounted) {
      TrackDetailsRoute(trackId: id).go(context);
    }
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

  Future<ServiceRequestResult> _startService(
    String notificationTitle,
    String notificationText,
  ) async {
    logger.debug("Starting foreground service.");
    final serviceRequestResult = await FlutterForegroundTask.startService(
      serviceId: serviceId,
      notificationTitle: notificationTitle,
      notificationText: notificationText,
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
