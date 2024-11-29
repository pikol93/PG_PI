import "package:flutter/material.dart";
import "package:pi_mobile/widgets/tracks/common/entry_title.dart";
import "package:pi_mobile/widgets/tracks/common/entry_value.dart";

class Entry extends StatelessWidget {
  final String title;
  final String value;

  const Entry({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            EntryValue(value: value),
            EntryTitle(title: title),
          ],
        ),
      );
}
