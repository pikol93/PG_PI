import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/exercise_model.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";
import "package:pi_mobile/widgets/exercises/details/exercise_details_page.dart";

class ExerciseDetailsScreen extends ConsumerWidget with Logger {
  final int exerciseId;

  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
          .watch(exerciseModelsMapProvider)
          .whenDataOrEmptyScaffold(context, (modelMap) {
        final model = modelMap[exerciseId];

        if (model == null) {
          return AppScaffold(
            appBar: AppBar(
              title: Text(context.t.exercises.exerciseDetails),
            ),
            body: Center(
              child: Text("Invalid entry. $exerciseId"),
            ),
          );
        }

        return AppScaffold(
          appBar: AppBar(
            title: Text(context.t.exercises.exerciseDetails),
            actions: _buildActions(model),
          ),
          body: ExerciseDetailsPage(model: model),
        );
      });

  List<Widget>? _buildActions(ExerciseModel model) {
    if (!model.isDeletable) {
      return null;
    }

    return [
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () => _onDeleteTapped(model),
            child: Text(context.t.exercises.deleteExercise),
          ),
        ],
      ),
    ];
  }

  void _onDeleteTapped(ExerciseModel model) {
    logger.debug("Delete tapped for model: ${model.name} (${model.id})");
    // TODO: Implement deleting existing models
  }
}
