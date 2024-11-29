import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/utility/duration.dart";
import "package:pi_mobile/widgets/tracks/common/entry.dart";

class DurationWidget extends StatelessWidget {
  final Duration duration;

  const DurationWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) => Entry(
        title: context.t.tracks.duration,
        value: duration.toHoursMinutes(),
      );
}
