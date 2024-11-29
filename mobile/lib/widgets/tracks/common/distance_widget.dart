import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/widgets/tracks/common/entry.dart";

class DistanceWidget extends StatelessWidget {
  final double distanceMeters;

  const DistanceWidget({super.key, required this.distanceMeters});

  @override
  Widget build(BuildContext context) => Entry(
        title: context.t.tracks.distance,
        value: "$distanceMeters",
      );
}
