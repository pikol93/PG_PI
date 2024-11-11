import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:pi_mobile/provider/tracks_provider.dart";
import "package:pi_mobile/widgets/calendar/calendar_data.dart";
import "package:pi_mobile/widgets/calendar/calendar_event_details.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "calendar_day_details.g.dart";

@riverpod
Future<List<Widget>> dayDetails(DayDetailsRef ref) async {
  final heartRateManager = await ref.watch(heartRateManagerProvider.future);
  final tracksManager = await ref.watch(tracksManagerProvider.future);
  final focusedDay = ref.watch(focusedDayProvider);

  final heartRateEntries =
      await heartRateManager.getHeartRateEntriesOn(focusedDay);
  final heartRateWidgets = heartRateEntries.map(
    (item) => HeartRateCalendarEventDetails(heartRate: item) as Widget,
  );

  final trackEntries = await tracksManager.getTrackEntriesOn(focusedDay);
  final tracksWidgets = trackEntries.map(
    (item) => TrackCalendarEventDetails(track: item) as Widget,
  );

  return heartRateWidgets.concat(tracksWidgets).toList();
}

class CalendarDayDetails extends ConsumerWidget {
  const CalendarDayDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDate = ref.watch(focusedDayProvider);
    final formattedDate = ref.read(dateFormatterProvider).fullDate(focusedDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: context.textStyles.titleMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: getDetailsWidget(ref),
        ),
      ],
    );
  }

  Widget getDetailsWidget(WidgetRef ref) => ref.watch(dayDetailsProvider).when(
        data: (data) => Column(children: data),
        error: (error, stackTrace) => Center(
          child: Text("Error: $error"),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
}
