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
}
