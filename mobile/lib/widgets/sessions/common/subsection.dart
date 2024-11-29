import "dart:core";

import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class Subsection extends StatelessWidget {
  final String subsectionTitle;
  final Widget subsectionBody;

  const Subsection({
    super.key,
    required this.subsectionTitle,
    required this.subsectionBody,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SubsectionHeader(subsectionName: subsectionTitle),
            subsectionBody,
          ],
        ),
      );
}

class _SubsectionHeader extends StatelessWidget {
  final String subsectionName;

  const _SubsectionHeader({required this.subsectionName});

  @override
  Widget build(BuildContext context) => Text(
        subsectionName,
        style: context.textStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
      );
}
