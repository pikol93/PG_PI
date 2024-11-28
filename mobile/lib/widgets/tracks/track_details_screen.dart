import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/data/processed_track.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/tracks/tracks_provider.dart";
import "package:pi_mobile/widgets/tracks/tracks_details_page.dart";

class TrackDetailsScreen extends ConsumerStatefulWidget {
  final int trackId;

  const TrackDetailsScreen({
    super.key,
    required this.trackId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrackDetailsScreenState();
}

class _TrackDetailsScreenState extends ConsumerState<TrackDetailsScreen>
    with Logger {
  late Future<Track?> _readTrackFuture;

  @override
  void initState() {
    super.initState();
    _readTrackFuture = _readTrack();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.tracks.title),
        ),
        body: FutureBuilder(
          future: _readTrackFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final track = snapshot.data;
            if (track == null) {
              return const Center(
                child: Text("Could not read track from repository."),
              );
            }

            final processedTrack = ProcessedTrack.calculateFrom(track);
            return TracksDetailsPage(track: processedTrack);
          },
        ),
      );

  Future<Track?> _readTrack() async {
    final manager = await ref.read(tracksManagerProvider.future);
    return manager.getById(widget.trackId);
  }
}
