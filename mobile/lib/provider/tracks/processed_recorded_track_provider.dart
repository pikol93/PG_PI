import "package:pi_mobile/data/processed_track.dart";
import "package:pi_mobile/provider/tracks/recorded_track_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "processed_recorded_track_provider.g.dart";

@Riverpod(keepAlive: true)
class ProcessedRecordedTrack extends _$ProcessedRecordedTrack {
  @override
  ProcessedTrack? build() {
    final track = ref.watch(recordedTrackProvider);
    if (track == null) {
      return null;
    }

    return ProcessedTrack.calculateFrom(track);
  }
}
