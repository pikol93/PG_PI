import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";

class ExerciseListEntry extends StatelessWidget with Logger {
  final int exerciseId;
  final String exerciseName;
  final double? oneRepMax;

  const ExerciseListEntry({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    this.oneRepMax,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          InkWell(
            onTap: () => _onTapped(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.fitness_center),
                  ),
                  _buildTextWidgetsColumn(context),
                ],
              ),
            ),
          ),
          const Divider(height: 0.0),
        ],
      );

  Widget _buildTextWidgetsColumn(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exerciseName,
                style: context.textStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    oneRepMax == null
                        ? " "
                        : "1RM: ${oneRepMax!.toStringAsFixed(1)}",
                    style: context.textStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void _onTapped(BuildContext context) {
    logger.debug("Tapped exercise \"$exerciseName\" (ID = $exerciseId)");
    ExerciseDetailsRoute(exerciseId: exerciseId).go(context);
  }
}
