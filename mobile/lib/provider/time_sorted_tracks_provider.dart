import "package:collection/collection.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "time_sorted_tracks_provider.g.dart";

// TODO: Consider allowing sorting tracks by different keys.

@Riverpod(keepAlive: true)
class TimeSortedTracks extends _$TimeSortedTracks {
  @override
  Future<List<Track>> build() async {
    final tracks = await ref.watch(tracksProvider.future);
    return tracks.sortedBy((track) => track.startTime).reversed.toList();
  }
}
