import "package:freezed_annotation/freezed_annotation.dart";
import "package:latlong2/latlong.dart";

part "location.g.dart";

part "location.freezed.dart";

@freezed
class Location with _$Location {
  static const Distance distance = Distance();

  const factory Location({
    required DateTime dateTime,
    required double longitude,
    required double latitude,
  }) = _Location;

  factory Location.fromJson(
    Map<String, Object?> json,
  ) =>
      _$LocationFromJson(json);

  static double getVelocityBetweenLocations(Location a, Location b) {
    final distance = getMetersBetweenLocations(a, b);
    final duration = getSecondsBetweenLocations(a, b);
    return distance / duration;
  }

  static double getMetersBetweenLocations(Location a, Location b) {
    final positionA = LatLng(a.latitude, a.longitude);
    final positionB = LatLng(b.latitude, b.longitude);

    return distance.as(LengthUnit.Meter, positionA, positionB);
  }

  static double getSecondsBetweenLocations(Location a, Location b) =>
      (b.dateTime.millisecondsSinceEpoch - a.dateTime.millisecondsSinceEpoch) /
      1000.0;
}
