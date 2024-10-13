import "package:pi_mobile/data/location.dart";
import "package:pi_mobile/data/mutable_track.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "recorded_track_provider.g.dart";

@Riverpod(keepAlive: true)
class RecordedTrack extends _$RecordedTrack with Logger {
  @override
  MutableTrack? build() => null;

  void initialize() {}

  void appendLocation(Location location) {
    logger.debug("Appending location: $location");
  }

  Track? convertCollectedDataToTrack() => null;

  void clear() {}
}
