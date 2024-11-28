import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/preferences/date_formatter_provider.dart";
import "package:pi_mobile/routing/routes_routines.dart";
import "package:pi_mobile/utility/option.dart";

class SingleRoutineEntryWidget extends StatelessWidget with Logger {
  final int routineId;
  final String routineName;
  final String author;
  final Option<DateTime> lastUsageTime;

  const SingleRoutineEntryWidget({
    super.key,
    required this.routineId,
    required this.routineName,
    required this.author,
    required this.lastUsageTime,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _onTapped(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _SingleRoutineEntryIcon(),
              _SingleRoutineEntryText(
                routineName: routineName,
                author: author,
                lastUsageTime: lastUsageTime,
              ),
            ],
          ),
        ),
      );

  void _onTapped(BuildContext context) {
    logger.debug("Tapped routing entry");
    RoutineRoute(routineId: routineId).go(context);
  }
}

class _SingleRoutineEntryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: 30,
        backgroundColor: context.colors.scheme.primaryContainer,
        child: const Icon(Icons.fitness_center, size: 30),
      );
}

class _SingleRoutineEntryText extends ConsumerWidget with Logger {
  final String routineName;
  final String author;
  final Option<DateTime> lastUsageTime;

  const _SingleRoutineEntryText({
    required this.routineName,
    required this.author,
    required this.lastUsageTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleTextStyle = context.textStyles.bodyMedium.copyWith(
      fontWeight: FontWeight.w200,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              routineName,
              style: context.textStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  author,
                  style: subtitleTextStyle,
                ),
                Text(
                  lastUsageTime
                      .map(
                        (lastUsageTime) => ref
                            .read(dateFormatterProvider)
                            .fullDate(lastUsageTime),
                      )
                      .orElse(""),
                  style: subtitleTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
