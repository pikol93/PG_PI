import "package:pi_mobile/data/location.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/utility/iterable.dart";

class ProcessedTrack {
  final Track track;
  final List<double> velocities;
  final double averageVelocity;
  final double averageMovingVelocity;
  final Duration totalDuration;
  final double totalLength;

  ProcessedTrack({
    required this.track,
    required this.velocities,
    required this.averageVelocity,
    required this.averageMovingVelocity,
    required this.totalDuration,
    required this.totalLength,
  });

  factory ProcessedTrack.calculateFrom(Track track) {
    final velocities = getVelocityListFromTrack(track);
    final averageVelocity = velocities.averageOrDefault;
    final averageMovingVelocity = getAverageMovingVelocity(velocities);
    return ProcessedTrack(
      track: track,
      velocities: velocities,
      averageVelocity: averageVelocity,
      averageMovingVelocity: averageMovingVelocity,
      totalDuration: track.getTotalTime(),
      totalLength: track.getTotalLength(),
    );
  }

  static List<double> getVelocityListFromTrack(Track track) {
    final locations = track.locations;
    if (locations.length <= 1) {
      return [];
    }

    final result = <double>[];
    for (var i = 0; i < locations.length - 1; i++) {
      final velocity = Location.getVelocityBetweenLocations(
        locations[i],
        locations[i + 1],
      );

      result.add(velocity);
    }

    return result;
  }

  static double getAverageMovingVelocity(List<double> velocities) {
    const metersPerSecondThreshold = 1.0;
    return velocities
        .where((velocity) => velocity > metersPerSecondThreshold)
        .averageOrDefault;
  }
}
