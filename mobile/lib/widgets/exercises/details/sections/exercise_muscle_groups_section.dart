import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/data/muscle_group.dart";
import "package:pi_mobile/i18n/strings.g.dart" as i18n;

class ExerciseMuscleGroupsSection extends StatelessWidget {
  final List<MuscleGroup> primaryMuscleGroups;
  final List<MuscleGroup>? secondaryMuscleGroups;

  const ExerciseMuscleGroupsSection({
    super.key,
    required this.primaryMuscleGroups,
    required this.secondaryMuscleGroups,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.t.exercises.primaryMuscleGroups,
            style: context.textStyles.titleMedium,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: primaryMuscleGroups
                .map((item) => _muscleGroupToWidget(context, item))
                .toList(),
          ),
        ],
      ),
    ];

    if (secondaryMuscleGroups != null && secondaryMuscleGroups!.isNotEmpty) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.t.exercises.secondaryMuscleGroups,
              style: context.textStyles.titleMedium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: secondaryMuscleGroups!
                  .map((item) => _muscleGroupToWidget(context, item))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            context.t.exercises.muscleGroups,
            style: context.textStyles.headlineMedium,
          ),
        ),
        Column(
          children: sections,
        ),
      ],
    );
  }

  Widget _muscleGroupToWidget(BuildContext context, MuscleGroup muscleGroup) {
    final exercisesTranslation = context.t.exercises;
    final translatedMuscleGroup = exercisesTranslation.muscleGroup(
      context: muscleGroup.toTranslationVariant(),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("• $translatedMuscleGroup"),
    );
  }
}
