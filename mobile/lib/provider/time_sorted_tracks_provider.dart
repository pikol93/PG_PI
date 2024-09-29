import "package:pi_mobile/data/location.dart";
import "package:pi_mobile/data/track.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "time_sorted_tracks_provider.g.dart";

// TODO: Consider allowing sorting tracks by different keys.

@Riverpod(keepAlive: true)
class TimeSortedTracks extends _$TimeSortedTracks {
  @override
  Future<List<Track>> build() async => [
        Track(
          uuid: "uuid1",
          startTime: DateTime.now().add(const Duration(minutes: 2)),
          locations: [
            Location(
              dateTime: DateTime.now()
                  .add(const Duration(minutes: 2))
                  .add(const Duration(seconds: 5)),
              longitude: 0.1,
              latitude: 0.2,
            ),
          ],
        ),
        Track(
          uuid: "uuid2",
          startTime: DateTime.now().add(const Duration(hours: 2)),
          locations: [
            Location(
              dateTime: DateTime.now()
                  .add(const Duration(hours: 2))
                  .add(const Duration(seconds: 5)),
              longitude: 0.1,
              latitude: 0.2,
            ),
          ],
        ),
        Track(
          uuid: "uuid3",
          startTime: DateTime.now().add(const Duration(days: 2)),
          locations: [
            Location(
              dateTime: DateTime.now()
                  .add(const Duration(days: 2))
                  .add(const Duration(seconds: 5)),
              longitude: 0.1,
              latitude: 0.2,
            ),
          ],
        ),
        Track(
          uuid: "uuid4",
          startTime: DateTime.now().add(const Duration(days: 37)),
          locations: [
            Location(
              dateTime: DateTime.now()
                  .add(const Duration(days: 37))
                  .add(const Duration(seconds: 5)),
              longitude: 0.1,
              latitude: 0.2,
            ),
          ],
        ),
      ];
}
