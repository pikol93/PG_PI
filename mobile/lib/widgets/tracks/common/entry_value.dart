import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class EntryValue extends StatelessWidget {
  final String value;

  const EntryValue({super.key, required this.value});

  @override
  Widget build(BuildContext context) => Text(
        value,
        style: context.textStyles.displayMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
      );
}
