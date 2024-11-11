import "package:flutter/material.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/data/collections/track.dart";

class HeartRateCalendarEventDetails extends StatelessWidget {
  final HeartRate heartRate;

  const HeartRateCalendarEventDetails({
    super.key,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context) => Text(
        "heart rate calendar day details:"
        " ${heartRate.time}"
        " ${heartRate.beatsPerMinute}",
      );
}

class TrackCalendarEventDetails extends StatelessWidget {
  final Track track;

  const TrackCalendarEventDetails({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) => Text(
        "track calendar day details:"
        " ${track.startTime}",
      );
}
