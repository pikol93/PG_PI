import "package:pi_mobile/data/location.dart";
import "package:pi_mobile/data/track.dart";

class MutableTrack {
  final String uuid;
  final DateTime startTime;
  final List<Location> locations = [];

  MutableTrack({
    required this.uuid,
    required this.startTime,
  });

  void appendLocation(Location location) {
    locations.add(location);
  }

  Track bake() => Track(
        uuid: uuid,
        startTime: startTime,
        locations: locations,
      );

  Track bakeWithTruncatedLocations() {
    const truncateThreshold = 10.0;
    final locationsCopy = locations.toList();
    for (var i = locationsCopy.length - 2; i >= 1; i--) {
      final locationA = locationsCopy[i - 1];
      final locationB = locationsCopy[i + 1];
      final distance = Location.getMetersBetweenLocations(locationA, locationB);

      if (distance < truncateThreshold) {
        locationsCopy.removeAt(i);
      }
    }

    return Track(
      uuid: uuid,
      startTime: startTime,
      locations: locationsCopy,
    );
  }
}
