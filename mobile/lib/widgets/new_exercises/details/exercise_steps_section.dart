import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";

class ExerciseStepsSection extends StatelessWidget {
  final List<String> steps;

  const ExerciseStepsSection({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              context.t.exercises.steps,
              style: context.textStyles.headlineMedium,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: steps.indexed
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${item.$1 + 1}. ${item.$2}"),
                  ),
                )
                .toList(),
          ),
        ],
      );
}
