import "package:freezed_annotation/freezed_annotation.dart";

part "heart_rate_entry.g.dart";

part "heart_rate_entry.freezed.dart";

@freezed
class HeartRateEntry with _$HeartRateEntry {
  const factory HeartRateEntry({
    required DateTime dateTime,
    required double beatsPerMinute,
  }) = _HeartRateEntry;

  factory HeartRateEntry.fromJson(Map<String, Object?> json) =>
      _$HeartRateEntryFromJson(json);
}
