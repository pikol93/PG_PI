import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercises_screen_entries_provider.dart";
import "package:pi_mobile/routing/routes_exercises.dart";
import "package:pi_mobile/utility/async_value.dart";

class ExerciseOneRepMaxSection extends ConsumerWidget with Logger {
  final int exerciseId;

  const ExerciseOneRepMaxSection({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
          .watch(exerciseScreenEntriesProvider)
          .whenDataOrDefault(context, (entriesList) {
        final entry = entriesList
            .where((item) => item.id == exerciseId)
            .map((item) => item.oneRepMaxHistory.toNullable())
            .firstOrNull;

        if (entry == null || entry.oneRepMaxHistory.isEmpty) {
          return const SizedBox.shrink();
        }

        final rows = [
          const TableRow(
            children: [
              Text("Date"),
              Text("1RM (kg)"),
            ],
          ),
        ];

        rows.addAll(
          entry.oneRepMaxHistory.sortedBy((item) => item.dateTime).reversed.map(
                (item) => TableRow(
                  children: [
                    Text(DateFormat.yMd().format(item.dateTime)),
                    Text(item.value.toStringAsFixed(1)),
                  ],
                ),
              ),
        );

        // TODO: Add a chart
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "1RM", // TODO: I18N
                    style: context.textStyles.headlineMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onModifyPressed(context),
                      child: const Text("Modify"), // TODO: I18N
                    ),
                  ],
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              children: rows,
            ),
          ],
        );
      });

  void _onModifyPressed(BuildContext context) {
    logger.debug("Modify pressed for $exerciseId");
    ExerciseModifyOneRepMaxRoute(exerciseId: exerciseId).go(context);
  }
}
