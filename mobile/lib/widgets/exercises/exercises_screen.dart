import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/exercise/exercises_screen_entries_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";
import "package:pi_mobile/widgets/exercises/exercise_list_entry.dart";

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(
        drawer: const AppNavigationDrawer(),
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: Text(context.t.exercises.title),
        ),
        body: ref.watch(exerciseScreenEntriesProvider).whenDataOrDefault(
              context,
              (models) => ListView.builder(
                itemCount: models.length,
                itemBuilder: (context, index) {
                  final model = models[index];
                  return ExerciseListEntry(
                    exerciseId: model.id,
                    exerciseName: model.name,
                    oneRepMax: model.oneRepMaxHistory
                        .map((item) => item.findCurrentOneRepMax())
                        .flatMap((item) => item)
                        .toNullable(),
                  );
                },
              ),
            ),
      );
}
