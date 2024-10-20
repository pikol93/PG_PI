import "dart:convert";
import "dart:math";

import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/random.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "heart_rate_list_provider.g.dart";

@Riverpod(keepAlive: true)
class HeartRateList extends _$HeartRateList with Logger {
  static const _keyName = "heart_rate";

  List<HeartRateEntry> entries = [];

  @override
  List<HeartRateEntry> build() => entries;

  Future<void> init() async {
    await _readAndUpdateFromStorage();
  }

  Future<void> addEntry(HeartRateEntry entry) async {
    entries.add(entry);
    await _writeToStorage();

    ref.invalidateSelf();
  }

  Future<void> replace(HeartRateEntry oldEntry, HeartRateEntry newEntry) async {
    entries.remove(oldEntry);
    entries.add(newEntry);
    await _writeToStorage();

    ref.invalidateSelf();
  }

  Future<void> clear() async {
    final preferences = SharedPreferencesAsync();
    await preferences.remove(_keyName);

    ref.invalidateSelf();
  }

  Future<void> generateHeartRateData() async {
    final random = Random();
    const minHeartRate = 65;
    const maxHeartRate = 75;
    const trend = -10;
    const processLength = Duration(days: 210);
    final startTime = DateTime.now().subtract(processLength);
    final endTime = DateTime.now();
    const durationMin = Duration(days: 2);
    const durationMax = Duration(days: 5);

    var currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      final nextDuration = random.nextDuration(durationMin, durationMax);
      currentTime = currentTime.add(nextDuration);
      final timeSinceStart = currentTime.difference(startTime);
      final progress =
          timeSinceStart.inMilliseconds / processLength.inMilliseconds;
      final trendIncrease = progress * trend;
      final baseHeartRate = random.nextRange(minHeartRate, maxHeartRate);
      final actualHeartRate = baseHeartRate + trendIncrease;
      final entry = HeartRateEntry(
        dateTime: currentTime,
        beatsPerMinute: actualHeartRate,
      );

      entries.add(entry);
    }

    ref.invalidateSelf();
  }

  Future<void> _readAndUpdateFromStorage() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final readTracks = jsonList
        .map((json) => HeartRateEntry.fromJson(jsonDecode(json)))
        .toList();

    logger.debug("Read ${readTracks.length} heart rate instances");
    entries = readTracks;
    ref.invalidateSelf();
  }

  Future<void> _writeToStorage() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = entries.map(jsonEncode).toList();
    return preferences.setStringList(_keyName, jsonList);
  }
}
