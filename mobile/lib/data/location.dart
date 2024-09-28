import "package:freezed_annotation/freezed_annotation.dart";

part "location.g.dart";

part "location.freezed.dart";

@freezed
class Location with _$Location {
  const factory Location({
    required DateTime dateTime,
    required double longitude,
    required double latitude,
  }) = _Location;

  factory Location.fromJson(
    Map<String, Object?> json,
  ) =>
      _$LocationFromJson(json);
}
