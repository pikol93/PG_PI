import "package:pi_mobile/data/location.dart";
import "package:pi_mobile/data/mutable_track.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "recorded_track_provider.g.dart";

@Riverpod(keepAlive: true)
class RecordedTrack extends _$RecordedTrack with Logger {
  MutableTrack? currentTrack;

  @override
  Track? build() => currentTrack?.bakeWithTruncatedLocations();

  void initialize() {
    if (currentTrack != null) {
      // TODO: Handle this case.
      throw StateError("Cannot initialize since track is already initialized.");
    }

    final uuid = const Uuid().v4();
    currentTrack = MutableTrack(
      uuid: uuid,
      startTime: DateTime.now(),
    );

    ref.invalidateSelf();
  }

  void appendLocation(Location location) {
    if (currentTrack == null) {
      logger.error("Cannot append location! Current track is null.");
      return;
    }

    logger.debug("Appending location: $location");
    currentTrack!.appendLocation(location);

    ref.invalidateSelf();
  }

  void clear() => currentTrack = null;
}
