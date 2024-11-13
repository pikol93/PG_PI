import "dart:math";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:isar/isar.dart";
import "package:latlong2/latlong.dart";
import "package:pi_mobile/data/collections/track.dart" as temp;
import "package:pi_mobile/provider/isar_provider.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/utility/random.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "tracks_provider.g.dart";

@riverpod
Future<List<temp.Track>> tracksTemp(Ref ref) async {
  final manager = await ref.watch(tracksManagerProvider.future);
  return manager.getAllSortedByTimeDescending();
}

@Riverpod(keepAlive: true)
Future<TracksManager> tracksManager(Ref ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return TracksManager(
    ref: ref,
    isar: isar,
  );
}

class TracksManager {
  final Ref ref;
  final Isar isar;

  TracksManager({
    required this.ref,
    required this.isar,
  });

  Future<temp.Track?> getById(int id) => isar.tracks.get(id);

  Future<List<temp.Track>> getAllSortedByTimeDescending() =>
      isar.tracks.where().sortByStartTimeDesc().findAll();

  Future<List<temp.Track>> getTrackEntriesOn(DateTime date) => isar.tracks
      .where()
      .startTimeBetween(date.toMidnightSameDay(), date.toMidnightNextDay())
      .findAll();

  Future<int> save(temp.Track track) async {
    final result = await _save(track);
    ref.invalidateSelf();
    return result;
  }

  Future<void> clear() => isar.writeTxn(() => isar.tracks.clear());

  Future<void> generateTracks() async {
    const processLength = Duration(days: 210);
    const durationMin = Duration(days: 2);
    const durationMax = Duration(days: 7);
    const runDurationMin = Duration(minutes: 20);
    const runDurationMax = Duration(minutes: 100);

    final random = Random();
    final startTime = DateTime.now().subtract(processLength);
    final endTime = DateTime.now();

    var currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      final runDuration = random.nextDuration(runDurationMin, runDurationMax);
      final endingTime = currentTime.add(runDuration);
      final track = _generateTrack(random, currentTime, endingTime);

      await _save(track);

      final nextDuration = random.nextDuration(durationMin, durationMax);
      currentTime = currentTime.add(nextDuration);
    }

    ref.invalidateSelf();
  }

  Future<int> _save(temp.Track track) =>
      isar.writeTxn(() => isar.tracks.put(track));

  temp.Track _generateTrack(
    Random random,
    DateTime startingTime,
    DateTime endingTime,
  ) {
    const distance = Distance();
    const minLocationWaitDuration = Duration(seconds: 3);
    const maxLocationWaitDuration = Duration(seconds: 5);
    const minLatitude = 51.656;
    const maxLatitude = 52.019;
    const minLongitude = 17.776;
    const maxLongitude = 20.056;
    const minBaseSpeed = 3.5;
    const maxBaseSpeed = 4.0;
    const minSpeedVariation = -0.5;
    const maxSpeedVariation = 0.5;
    const minBaseBearing = 0.0;
    const maxBaseBearing = 360.0;
    const minBearingVariation = 2.0;
    const maxBearingVariation = 20.0;

    final baseSpeed = random.nextRangeDouble(minBaseSpeed, maxBaseSpeed);
    final baseBearing = random.nextRangeDouble(minBaseBearing, maxBaseBearing);

    var time = startingTime;
    var position = LatLng(
      random.nextRangeDouble(minLatitude, maxLatitude),
      random.nextRangeDouble(minLongitude, maxLongitude),
    );

    final locationRecords = <temp.LocationRecord>[];

    while (time.isBefore(endingTime)) {
      final duration = random.nextDuration(
        minLocationWaitDuration,
        maxLocationWaitDuration,
      );
      final speed = baseSpeed +
          random.nextRangeDouble(
            minSpeedVariation,
            maxSpeedVariation,
          );
      final distanceTravelled = speed * (duration.inMilliseconds / 1000.0);
      final bearing = baseBearing +
          random.nextRangeDouble(
            minBearingVariation,
            maxBearingVariation,
          );

      position = distance.offset(
        position,
        distanceTravelled,
        bearing,
      );

      locationRecords.add(
        temp.LocationRecord()
          ..dateTime = time
          ..latitude = position.latitude
          ..longitude = position.longitude,
      );

      time = time.add(duration);
    }

    return temp.Track()
      ..startTime = startingTime
      ..locations = locationRecords;
  }
}
