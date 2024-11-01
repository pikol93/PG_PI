import "package:isar/isar.dart";
import "package:latlong2/latlong.dart";

part "track.g.dart";

@collection
class Track {
  @Index(type: IndexType.value)
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime startTime;

  late List<LocationRecord> locations;

  Duration getTotalTime() {
    // Assumption: locations are sorted chronologically.
    final lastLocation = locations.lastOrNull;
    if (lastLocation == null) {
      return Duration.zero;
    }

    return lastLocation.dateTime.difference(startTime);
  }

  double getTotalLength() {
    var result = 0.0;
    for (var i = 0; i < locations.length - 1; i++) {
      final locationA = locations[i];
      final locationB = locations[i + 1];
      final distance = LocationRecord.getMetersBetweenLocations(
        locationA,
        locationB,
      );
      result += distance;
    }

    return result;
  }
}

@embedded
class LocationRecord {
  static const Distance distance = Distance();

  late DateTime dateTime;
  late float longitude;
  late float latitude;

  static double getVelocityBetweenLocations(
    LocationRecord a,
    LocationRecord b,
  ) {
    final distance = getMetersBetweenLocations(a, b);
    final duration = getSecondsBetweenLocations(a, b);
    return distance / duration;
  }

  static double getMetersBetweenLocations(
    LocationRecord a,
    LocationRecord b,
  ) {
    final positionA = LatLng(a.latitude, a.longitude);
    final positionB = LatLng(b.latitude, b.longitude);

    return distance.as(LengthUnit.Meter, positionA, positionB);
  }

  static double getSecondsBetweenLocations(
    LocationRecord a,
    LocationRecord b,
  ) =>
      (b.dateTime.millisecondsSinceEpoch - a.dateTime.millisecondsSinceEpoch) /
      1000.0;
}
