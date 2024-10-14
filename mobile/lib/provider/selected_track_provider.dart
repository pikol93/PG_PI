import "package:pi_mobile/data/processed_track.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "selected_track_provider.g.dart";

@Riverpod(keepAlive: true)
class SelectedTrack extends _$SelectedTrack {
  String selectedUuid = "";

  @override
  Future<ProcessedTrack?> build() async {
    final tracks = await ref.watch(tracksProvider.future);
    if (selectedUuid.isEmpty) {
      return null;
    }

    return tracks
        .where((track) => track.uuid == selectedUuid)
        .map(ProcessedTrack.calculateFrom)
        .firstOrNull;
  }

  void updateTrack(Track track) {
    selectedUuid = track.uuid;
    ref.invalidateSelf();
  }
}
