import "package:flutter/material.dart";
import "package:pi_mobile/data/processed_track.dart";

class TracksDetailsPage extends StatelessWidget {
  final ProcessedTrack track;

  const TracksDetailsPage({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Text("${track.averageVelocity}"),
      );
}
