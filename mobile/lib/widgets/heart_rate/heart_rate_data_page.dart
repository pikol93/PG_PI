import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:pi_mobile/routing/routes.dart";

class HeartRateDataPage extends ConsumerWidget {
  static final dateFormat = DateFormat();

  const HeartRateDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(sortedHeartRateListProvider).when(
            data: (data) => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (context, index) => _itemBuilder(
                data[index],
                context,
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Text("$error"),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );

  Widget _itemBuilder(HeartRate entry, BuildContext context) => InkWell(
        onTap: () => _onEntryTapped(context, entry),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dateFormat.format(entry.time),
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

  void _onEntryTapped(BuildContext context, HeartRate entry) {
    ModifyHeartRateRoute(
      entryId: entry.id!,
    ).go(context);
  }
}
