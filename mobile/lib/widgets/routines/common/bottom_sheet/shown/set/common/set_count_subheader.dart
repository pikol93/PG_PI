import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class SetCountSubheader extends StatelessWidget {
  final int setIndex;
  final int setTotalCount;

  const SetCountSubheader({
    super.key,
    required this.setIndex,
    required this.setTotalCount,
  });

  @override
  Widget build(BuildContext context) => Text(
        "Set ${setIndex + 1} / $setTotalCount", // TODO: I18N
        textAlign: TextAlign.center,
        style: context.textStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w300,
          color: context.colors.scheme.secondary,
        ),
      );
}
