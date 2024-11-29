import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/widgets/tracks/common/entry.dart";

class MovingVelocityWidget extends StatelessWidget {
  final double metersPerSecond;

  const MovingVelocityWidget({super.key, required this.metersPerSecond});

  @override
  Widget build(BuildContext context) => Entry(
        title: context.t.tracks.movingVelocity,
        value: _metersPerSecondToKilometersPerHour(metersPerSecond)
            .toStringAsFixed(1),
      );

  static double _metersPerSecondToKilometersPerHour(double value) =>
      value * 3.6;
}
