import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/data/mutable_track.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "recorded_track_provider.g.dart";

@Riverpod(keepAlive: true)
class RecordedTrack extends _$RecordedTrack with Logger {
  MutableTrack? currentTrack;

  @override
  Track? build() => currentTrack?.bakeWithTruncatedLocations();

  void initializeIfNotInitialized() {
    if (currentTrack != null) {
      logger.debug("Already initialized. Skipping initialization.");
      return;
    }

    currentTrack = MutableTrack(
      startTime: DateTime.now(),
    );

    ref.invalidateSelf();
  }

  void appendLocation(LocationRecord location) {
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
