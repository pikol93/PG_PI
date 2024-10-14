import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/track.dart";

part "tracks_collection.g.dart";

part "tracks_collection.freezed.dart";

@freezed
class TracksCollection with _$TracksCollection {
  const factory TracksCollection({
    required List<Track> tracks,
  }) = _TracksCollection;

  factory TracksCollection.fromJson(
    Map<String, Object?> json,
  ) =>
      _$TracksCollectionFromJson(json);
}
