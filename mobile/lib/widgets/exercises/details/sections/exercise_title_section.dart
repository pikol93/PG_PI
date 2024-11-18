import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class ExerciseTitleSection extends StatelessWidget {
  final String title;
  final String? author;

  const ExerciseTitleSection({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final texts = [
      Text(
        title,
        style: context.textStyles.displayMedium,
      ),
    ];

    if (author != null) {
      texts.add(
        Text(
          author!,
          style: context.textStyles.labelLarge.copyWith(
            color: context.colors.secondaryHeader,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(128, 128, 128, 128),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.fitness_center,
                  size: 64.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: texts,
            ),
          ),
        ],
      ),
    );
  }
}
