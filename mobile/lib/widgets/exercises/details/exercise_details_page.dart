import "package:flutter/material.dart";
import "package:pi_mobile/provider/exercise/exercise_model.dart";
import "package:pi_mobile/widgets/exercises/details/sections/exercise_muscle_groups_section.dart";
import "package:pi_mobile/widgets/exercises/details/sections/exercise_one_rep_max_section.dart";
import "package:pi_mobile/widgets/exercises/details/sections/exercise_steps_section.dart";
import "package:pi_mobile/widgets/exercises/details/sections/exercise_title_section.dart";

class ExerciseDetailsPage extends StatelessWidget {
  final ExerciseModel model;

  const ExerciseDetailsPage({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      ExerciseTitleSection(
        title: model.name,
        author: model.author,
      ),
      ExerciseMuscleGroupsSection(
        primaryMuscleGroups: model.primaryMuscleGroups,
        secondaryMuscleGroups: model.secondaryMuscleGroups,
      ),
      ExerciseStepsSection(
        steps: model.steps,
      ),
    ];

    if (model.isOneRepMaxMeasurable) {
      sections.add(
        ExerciseOneRepMaxSection(
          exerciseId: model.id,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              children: sections,
            ),
          ),
        ],
      ),
    );
  }
}
