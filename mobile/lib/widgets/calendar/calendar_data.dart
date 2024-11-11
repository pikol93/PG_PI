import "package:collection/collection.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:table_calendar/table_calendar.dart";

part "calendar_data.g.dart";

@riverpod
Future<CalendarData> calendarData(CalendarDataRef ref) async {
  final heartRateList = await ref.watch(heartRateListProvider.future);
  final trackList = await ref.watch(tracksTempProvider.future);

  return CalendarData(
    heartRateList: heartRateList,
    trackList: trackList,
  );
}

class CalendarData {
  final List<HeartRate> heartRateList;
  final List<Track> trackList;

  CalendarData({
    required this.heartRateList,
    required this.trackList,
  });

  bool hasAnyHeartRateEntryOn(DateTime date) =>
      heartRateList.any((item) => isSameDay(date, item.time));

  bool hasAnyTracksOn(DateTime date) =>
      trackList.any((item) => isSameDay(date, item.startTime));

  // TODO: Finish this.
  bool hasAnyExercisesOn(DateTime date) => false;

  DateTime? getMinDate() => heartRateList
      .map((item) => item.time)
      .concat(trackList.map((item) => item.startTime))
      .minOrNull;
}
