import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:pi_mobile/provider/heart_rate_list_sorted_provider.dart";

class HeartRateDataPage extends ConsumerWidget {
  static final dateFormat = DateFormat();

  const HeartRateDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(sortedHeartRateListProvider).when(
            data: (entries) => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (context, index) => _itemBuilder(
                entries[index],
                context,
              ),
            ),
            error: (a, b) => Center(
              child: Text("Could not fetch heart rate data. $a"),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );

  Widget _itemBuilder(HeartRateEntry entry, BuildContext context) => InkWell(
        onTap: () => _onEntryTapped(context, entry),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dateFormat.format(entry.dateTime),
                      style: context.textStyles.bodyLarge,
                    ),
                  ),
                  Text(
                    "${entry.beatsPerMinute.toInt()} BPM",
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const Divider(height: 0.0),
          ],
        ),
      );

  void _onEntryTapped(BuildContext context, HeartRateEntry entry) {}
}
