import "dart:async";
import "package:fl_location/fl_location.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/location_service_status_provider.dart";

class RecordTrackBottomSheet extends ConsumerStatefulWidget {
  const RecordTrackBottomSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecordTrackBottomSheetState();
}

class _RecordTrackBottomSheetState
    extends ConsumerState<RecordTrackBottomSheet> {
  late final StreamSubscription<LocationServicesStatus> statusSubscription;

  @override
  void initState() {
    super.initState();

    statusSubscription = FlLocation.getLocationServicesStatusStream()
        .listen(_onLocationServicesChanged);
  }

  @override
  void dispose() {
    super.dispose();

    statusSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final locationServiceStatus =
        ref.watch(locationServiceStatusProvider).valueOrNull ??
            LocationServicesStatus.enabled;

    if (locationServiceStatus == LocationServicesStatus.enabled) {
      return const SizedBox.shrink();
    }

    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Enable location services to record your tracks"),
          ),
        ),
      ],
    );
  }

  void _onLocationServicesChanged(LocationServicesStatus status) {
    // TODO: This should not be here.
    ref.read(locationServiceStatusProvider.notifier).invalidate();
  }
}
