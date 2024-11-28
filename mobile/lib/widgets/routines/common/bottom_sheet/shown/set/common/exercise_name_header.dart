import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/widgets/common/exercise_icon.dart";

class ExerciseNameHeader extends StatelessWidget {
  final String exerciseName;

  const ExerciseNameHeader({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ExerciseIcon(),
          Text(
            exerciseName,
            style: context.textStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
