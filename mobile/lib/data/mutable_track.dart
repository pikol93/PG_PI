import "package:pi_mobile/data/collections/track.dart";

class MutableTrack {
  final DateTime startTime;
  final List<LocationRecord> locations = [];

  MutableTrack({
    required this.startTime,
  });

  void appendLocation(LocationRecord location) {
    locations.add(location);
  }

  Track bake() => Track()
    ..startTime = startTime
    ..locations = locations;

  Track bakeWithTruncatedLocations() {
    const truncateThreshold = 10.0;
    final locationsCopy = locations.toList();
    for (var i = locationsCopy.length - 2; i >= 1; i--) {
      final locationA = locationsCopy[i - 1];
      final locationB = locationsCopy[i + 1];
      final distance = LocationRecord.getMetersBetweenLocations(
        locationA,
        locationB,
      );

      if (distance < truncateThreshold) {
        locationsCopy.removeAt(i);
      }
    }

    return Track()
      ..startTime = startTime
      ..locations = locationsCopy;
  }
}
