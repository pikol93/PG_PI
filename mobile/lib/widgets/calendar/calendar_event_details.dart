import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/utility/duration.dart";

class HeartRateCalendarEventDetails extends ConsumerWidget {
  final HeartRate heartRate;

  const HeartRateCalendarEventDetails({
    super.key,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.read(dateFormatterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(dateFormatter.hourMinute(heartRate.time)),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.favorite),
                ],
              ),
              Text("${heartRate.beatsPerMinute.toInt()} BPM"),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackCalendarEventDetails extends ConsumerWidget {
  final Track track;

  const TrackCalendarEventDetails({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.read(dateFormatterProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(dateFormatter.hourMinute(track.startTime)),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.navigation),
                ],
              ),
              Text("${track.getTotalLength()} m"),
              Text(track.getTotalTime().toHoursMinutesSeconds()),
            ],
          ),
        ),
      ),
    );
  }
}
