import "package:pi_mobile/data/tracks_collection.dart";
import "package:pi_mobile/utility/shared_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "tracks_collection_instance_provider.g.dart";

@Riverpod(keepAlive: true)
class TracksCollectionInstance extends _$TracksCollectionInstance {
  static const keyName = "tracks";

  @override
  Future<TracksCollection> build() async {
    final preferences = SharedPreferencesAsync();
    final collection = await preferences.getFromJson<TracksCollection>(
          keyName,
          TracksCollection.fromJson,
        ) ??
        const TracksCollection(tracks: []);

    return collection;
  }
}
