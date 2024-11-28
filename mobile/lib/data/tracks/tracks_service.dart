import "dart:async";
import "dart:convert";

import "package:fl_location/fl_location.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:latlong2/latlong.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/data/tracks/recorded_track_provider.dart";
import "package:pi_mobile/data/tracks/track.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes_tracks.dart";

part "tracks_service.freezed.dart";
part "tracks_service.g.dart";

@freezed
class LocationEntry with _$LocationEntry {
  static const Distance distance = Distance();

  const factory LocationEntry({
    required DateTime dateTime,
    required double longitude,
    required double latitude,
  }) = _LocationEntry;

  factory LocationEntry.fromJson(
    Map<String, Object?> json,
  ) =>
      _$LocationEntryFromJson(json);

  static double getVelocityBetweenLocations(LocationEntry a, LocationEntry b) {
    final distance = getMetersBetweenLocations(a, b);
    final duration = getSecondsBetweenLocations(a, b);
    return distance / duration;
  }

  static double getMetersBetweenLocations(LocationEntry a, LocationEntry b) {
    final positionA = LatLng(a.latitude, a.longitude);
    final positionB = LatLng(b.latitude, b.longitude);

    return distance.as(LengthUnit.Meter, positionA, positionB);
  }

  static double getSecondsBetweenLocations(LocationEntry a, LocationEntry b) =>
      (b.dateTime.millisecondsSinceEpoch - a.dateTime.millisecondsSinceEpoch) /
      1000.0;
}

class LocationTaskHandler extends TaskHandler with Logger {
  StreamSubscription<LocationServicesStatus>? _servicesStatusSubscription;
  StreamSubscription<Location>? _streamSubscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // This handler can be thought of as a separate process than the main
    // application. This causes a need for separate initialization process.
    Loggy.initLoggy(logPrinter: const LoggerPrinter());

    logger.debug("onStart $timestamp");
    _servicesStatusSubscription =
        FlLocation.getLocationServicesStatusStream().listen(
      _onLocationServicesStatus,
    );

    final isLocationServiceEnabled = await FlLocation.isLocationServicesEnabled;
    if (isLocationServiceEnabled) {
      _processLocationServiceStatus(LocationServicesStatus.enabled);
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    logger.debug("onDestroy $timestamp");

    await _servicesStatusSubscription?.cancel();
    _servicesStatusSubscription = null;

    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // TODO: The location service can occasionally not start correctly when
    //  toggling the location setting.
    logger.debug("onRepeatEvent $timestamp ${_streamSubscription?.isPaused}");
  }

  @override
  void onNotificationPressed() {
    logger.debug("onNotificationPressed");
    FlutterForegroundTask.launchApp(const RecordTrackRoute().location);
  }

  void _processLocationServiceStatus(LocationServicesStatus status) {
    logger.debug("Processing location service status: $status");

    switch (status) {
      case LocationServicesStatus.disabled:
        _streamSubscription?.cancel();
        _streamSubscription = null;
      case LocationServicesStatus.enabled:
        _streamSubscription ??=
            FlLocation.getLocationStream().listen(_onLocation);
    }
  }

  void _onLocation(Location location) {
    logger.debug(
      "Status:"
      " ${location.millisecondsSinceEpoch},"
      " ${location.longitude},"
      " ${location.latitude}",
    );

    final internalLocation = LocationEntry(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        location.millisecondsSinceEpoch.toInt(),
      ),
      longitude: location.longitude,
      latitude: location.latitude,
    );

    final json = jsonEncode(internalLocation);
    FlutterForegroundTask.sendDataToMain(json);
  }

  void _onLocationServicesStatus(LocationServicesStatus status) {
    _processLocationServiceStatus(status);
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

    if (data is! String) {
      return;
    }
    final locationMap = jsonDecode(data);
    final location = LocationEntry.fromJson(locationMap);
    // TODO: Skip Location into LocationRecord conversion
    final locationRecord = LocationRecord()
      ..latitude = location.latitude
      ..longitude = location.longitude
      ..dateTime = location.dateTime;

    ref.read(recordedTrackProvider.notifier).appendLocation(locationRecord);
  }
}
