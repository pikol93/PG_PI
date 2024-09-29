import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/data/track.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/time_sorted_tracks_provider.dart";

class TracksList extends ConsumerWidget with Logger {
  static final dateFormat = DateFormat();

  const TracksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(timeSortedTracksProvider).when(
            error: (error, stack) => Text("Could not fetch tracks. $error"),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (tracks) => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tracks.length,
              itemBuilder: (context, index) => _itemBuilder(
                tracks,
                context,
                index,
              ),
            ),
          );

  Widget _itemBuilder(List<Track> tracks, BuildContext context, int index) {
    final track = tracks[index];
    return InkWell(
      onTap: () => _onTrackTapped(context, track),
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
                      dateFormat.format(track.startTime),
                      style: context.textStyles.bodyLarge,
                    ),
                    Text(
                      "TODO: Show time and distance",
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

  void _onTrackTapped(BuildContext context, Track track) {
    logger.debug("Track tapped: ${track.uuid}");
    // TODO: Route to track details page
  }
}
