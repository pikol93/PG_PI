import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:isar/isar.dart";
import "package:pi_mobile/data/heart_rate/heart_rate.dart";
import "package:pi_mobile/data/isar_provider.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/utility/random.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "heart_rate_list_provider.g.dart";

@riverpod
Future<List<HeartRate>> heartRateList(Ref ref) async {
  final heartRateManager = await ref.watch(heartRateManagerProvider.future);
  return heartRateManager.getAll();
}

@riverpod
Future<List<HeartRate>> sortedHeartRateList(Ref ref) async {
  final heartRateManager = await ref.watch(heartRateManagerProvider.future);
  return heartRateManager.getAllSortedByTimeDescending();
}

@riverpod
Future<List<FlSpot>> heartRateChartData(Ref ref) async {
  final heartRateManager = await ref.watch(heartRateManagerProvider.future);
  final heartRateList = await heartRateManager.getAllSortedByTimeAscending();

  return heartRateList
      .map(
        (entry) => FlSpot(
          entry.time.millisecondsSinceEpoch.toDouble(),
          entry.beatsPerMinute,
        ),
      )
      .toList();
}

@riverpod
Future<HeartRateManager> heartRateManager(Ref ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return HeartRateManager(ref: ref, isar: isar);
}

class HeartRateManager {
  final Ref ref;
  final Isar isar;

  HeartRateManager({
    required this.ref,
    required this.isar,
  });

  Future<int> save(HeartRate entry) async {
    final result = await _save(entry);
    ref.invalidateSelf();
    return result;
  }

  Future<List<HeartRate>> getAll() => isar.heartRates.where().findAll();

  Future<List<HeartRate>> getAllSortedByTimeAscending() =>
      isar.heartRates.where().sortByTime().findAll();

  Future<List<HeartRate>> getAllSortedByTimeDescending() =>
      isar.heartRates.where().sortByTimeDesc().findAll();

  Future<HeartRate?> getById(int id) => isar.heartRates.get(id);

  Future<List<HeartRate>> getHeartRateEntriesOn(DateTime date) =>
      isar.heartRates
          .where()
          .timeBetween(date.toMidnightSameDay(), date.toMidnightNextDay())
          .findAll();

  Future<void> clear() => isar.writeTxn(() => isar.heartRates.clear());

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
      final entry = HeartRate()
        ..time = currentTime
        ..beatsPerMinute = actualHeartRate;

      await _save(entry);
    }

    ref.invalidateSelf();
  }

  Future<int> _save(HeartRate entry) =>
      isar.writeTxn(() => isar.heartRates.put(entry));
}
