import "package:flutter/material.dart";
import "package:pi_mobile/data/tracks/processed_track.dart";
import "package:pi_mobile/widgets/tracks/common/distance_widget.dart";
import "package:pi_mobile/widgets/tracks/common/duration_widget.dart";
import "package:pi_mobile/widgets/tracks/common/moving_velocity_widget.dart";
import "package:pi_mobile/widgets/tracks/common/velocity_widget.dart";

class ProcessedTrackDetails extends StatelessWidget {
  final ProcessedTrack track;

  const ProcessedTrackDetails({super.key, required this.track});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DistanceWidget(distanceMeters: track.totalLength),
              DurationWidget(duration: track.totalDuration),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              VelocityWidget(metersPerSecond: track.averageVelocity),
              MovingVelocityWidget(metersPerSecond: track.averageVelocity),
            ],
          ),
        ],
      );
}
