import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/tracks/tracks_provider.dart";
import "package:pi_mobile/routing/routes_tracks.dart";
import "package:pi_mobile/utility/duration.dart";

class TracksList extends ConsumerWidget with Logger {
  static final dateFormat = DateFormat();

  const TracksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(tracksTempProvider).when(
            error: (error, stack) =>
                Text("${context.t.tracks.couldNotFetch} $error"),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (tracks) => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tracks.length,
              itemBuilder: (context, index) => _itemBuilder(
                tracks,
                context,
                index,
                ref,
              ),
            ),
          );

  Widget _itemBuilder(
    List<Track> tracks,
    BuildContext context,
    int index,
    WidgetRef ref,
  ) {
    final track = tracks[index];
    final trackLength = track.getTotalLength();
    final trackDuration = track.getTotalTime();
    return InkWell(
      onTap: () => _onTrackTapped(context, ref, track),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.navigation),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ref
                          .read(dateFormatterProvider)
                          .fullDateTime(track.startTime),
                      style: context.textStyles.bodyLarge,
                    ),
                    Text(
                      "$trackLength m"
                      " (${trackDuration.toHoursMinutesSeconds()})",
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 0.0),
        ],
      ),
    );
  }

  void _onTrackTapped(BuildContext context, WidgetRef ref, Track track) {
    logger.debug("Track tapped: ${track.id}");
    TrackDetailsRoute(trackId: track.id).go(context);
  }
}
