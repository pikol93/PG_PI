import "package:flutter/material.dart";
import "package:pi_mobile/data/tracks/processed_track.dart";
import "package:pi_mobile/widgets/tracks/common/processed_track_details.dart";

class TracksDetailsPage extends StatelessWidget {
  final ProcessedTrack track;

  const TracksDetailsPage({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: ProcessedTrackDetails(track: track),
      );
}
