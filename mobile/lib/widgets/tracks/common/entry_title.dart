import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class EntryTitle extends StatelessWidget {
  final String title;

  const EntryTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: context.textStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
}
