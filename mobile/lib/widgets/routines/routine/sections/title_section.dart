import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/data/routine/routine.dart";

class RoutineTitleSection extends StatelessWidget {
  final Routine routine;

  const RoutineTitleSection({super.key, required this.routine});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            _SingleRoutineEntryIcon(),
            _SingleRoutineEntryText(routineName: routine.name),
          ],
        ),
      );
}

class _SingleRoutineEntryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: 40,
        backgroundColor: context.colors.scheme.primaryContainer,
        child: const Icon(Icons.fitness_center, size: 40),
      );
}

class _SingleRoutineEntryText extends StatelessWidget {
  final String routineName;

  const _SingleRoutineEntryText({required this.routineName});

  @override
  Widget build(BuildContext context) {
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
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "author name",
                  style: subtitleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "how long ago",
                  style: subtitleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
