import "dart:convert";

import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "tracks_provider.g.dart";

@Riverpod(keepAlive: true)
class Tracks extends _$Tracks with Logger {
  static const _keyName = "tracks";

  @override
  Future<List<Track>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final tracks =
        jsonList.map((json) => Track.fromJson(jsonDecode(json))).toList();

    logger.debug("Read ${tracks.length} tracks");
    return tracks;
  }

  Future<void> addTrack(Track track) async {
    final list = await ref.read(tracksProvider.future);
    list.add(track);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }
}
