import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/provider/exercises_screen_entries_provider.dart";
import "package:pi_mobile/routing/routes_exercises.dart";
import "package:pi_mobile/utility/async_value.dart";

class ExerciseInspectOneRepMaxScreen extends ConsumerWidget with Logger {
  final int exerciseId;

  const ExerciseInspectOneRepMaxScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(dateFormatterProvider);

    return ref
        .watch(exerciseScreenEntriesProvider)
        .whenDataOrEmptyScaffold(context, (entriesList) {
      final entry = entriesList
          .where((item) => item.id == exerciseId)
          .map((item) => item.oneRepMaxHistory.toNullable())
          .firstOrNull;

      final appBar = AppBar(
        title: const Text("Inspect 1RM"), // TODO: I18N
      );

      if (entry == null || entry.oneRepMaxHistory.isEmpty) {
        return Scaffold(
          appBar: appBar,
          body: const SizedBox.shrink(),
        );
      }

      return Scaffold(
        appBar: appBar,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _onAddButtonPressed(context),
        ),
        body: ListView(
          children: entry.oneRepMaxHistory.reversed.indexed
              .map(
                (item) => InkWell(
                  onTap: () =>
                      _onRowTapped(context, exerciseId, item.$2.dateTime),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 64,
                          child: Text(
                            textAlign: TextAlign.center,
                            (item.$1 + 1).toString(),
                            style: context.textStyles.titleLarge,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateFormatter.fullDate(item.$2.dateTime),
                              style: context.textStyles.titleMedium,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${item.$2.value.toStringAsFixed(1)} kg",
                                style: context.textStyles.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }

  void _onRowTapped(BuildContext context, int exerciseId, DateTime dateTime) {
    logger.debug("Row tapped: $exerciseId, $dateTime");
    ExerciseModifySpecificOneRepMaxRoute(
      exerciseId: exerciseId,
      dateTimestamp: dateTime.millisecondsSinceEpoch,
    ).go(context);
  }

  void _onAddButtonPressed(BuildContext context) {
    ExerciseAddSpecificOneRepMaxRoute(exerciseId: exerciseId).go(context);
  }
}
