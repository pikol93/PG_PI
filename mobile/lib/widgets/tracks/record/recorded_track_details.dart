import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/tracks/processed_recorded_track_provider.dart";
import "package:pi_mobile/widgets/tracks/common/processed_track_details.dart";

class RecordedTrackDetails extends ConsumerWidget {
  const RecordedTrackDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(processedRecordedTrackProvider);
    if (track == null) {
      return const Text("No data");
    }

    return ProcessedTrackDetails(track: track);
  }
}
