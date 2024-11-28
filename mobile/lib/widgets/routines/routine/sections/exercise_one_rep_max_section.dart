import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart" as fpdart;
import "package:pi_mobile/data/exercise_model.dart";
import "package:pi_mobile/data/routine/routine.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/provider/exercise/exercise_models_provider.dart";
import "package:pi_mobile/provider/exercise/one_rep_max_service_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/iterable.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/utility/task.dart";
import "package:pi_mobile/widgets/routines/common/section_content.dart";
import "package:pi_mobile/widgets/routines/common/section_header.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exercise_one_rep_max_section.g.dart";

class _SectionServices {
  final Map<int, ExerciseModel> exerciseModelMap;
  final OneRepMaxService oneRepMaxService;

  const _SectionServices({
    required this.exerciseModelMap,
    required this.oneRepMaxService,
  });
}

@riverpod
Future<_SectionServices> _sectionServices(Ref ref) async => _SectionServices(
      exerciseModelMap: await ref.watch(exerciseModelsMapProvider.future),
      oneRepMaxService: await ref.watch(oneRepMaxServiceProvider.future),
    );

class _SectionEntryData {
  final String name;
  final fpdart.Option<double> oneRepMax;

  _SectionEntryData({required this.name, required this.oneRepMax});
}

class RoutineExerciseOneRepMaxSection extends StatelessWidget {
  final Routine routine;

  const RoutineExerciseOneRepMaxSection({super.key, required this.routine});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title: context.t.routines.routine.section.oneRepMax),
            _SectionInternal(routine: routine),
          ],
        ),
      );
}

class _SectionInternal extends ConsumerWidget {
  final Routine routine;

  const _SectionInternal({required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SectionContent(
        child: ref.watch(_sectionServicesProvider).whenDataOrDefault(
              context,
              (services) => _SectionEntries(
                oneRepMaxService: services.oneRepMaxService,
                exercises: routine.workouts
                    .flatMap((workout) => workout.exercises)
                    .map((exercise) => exercise.exerciseId)
                    .unique()
                    .map((id) => services.exerciseModelMap.get(id))
                    .filter((exercise) => exercise.isSome())
                    .map((exercise) => exercise.toNullable()!)
                    .sortWith(
                      (exercise) => exercise.name,
                      fpdart.Order.from(compareNatural),
                    )
                    .toList(),
              ),
            ),
      );
}

class _SectionEntries extends StatefulWidget {
  final OneRepMaxService oneRepMaxService;
  final List<ExerciseModel> exercises;

  const _SectionEntries({
    required this.oneRepMaxService,
    required this.exercises,
  });

  @override
  State<StatefulWidget> createState() => _SectionEntriesState();
}

class _SectionEntriesState extends State<_SectionEntries> {
  late Future<List<_SectionEntryData>> entriesDataFuture;

  @override
  void initState() {
    super.initState();
    _updateFuture();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: entriesDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(
              child: Text(context.t.general.noData),
            );
          }

          final nameTextStyle = context.textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w400,
          );
          final oneRepMaxTextStyle = context.textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          );

          return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
            },
            children: data
                .map(
                  (entry) => TableRow(
                    children: [
                      const Icon(Icons.fitness_center),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          entry.name,
                          style: nameTextStyle,
                        ),
                      ),
                      Text(
                        entry.oneRepMax
                            .map(
                              (oneRepMax) =>
                                  "${oneRepMax.toStringAsFixed(1)} kg",
                            )
                            .getOrElse(() => "-"),
                        style: oneRepMaxTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                .toList(),
          );
        },
      );

  void _updateFuture() {
    entriesDataFuture = widget.exercises
        .map(
          (exercise) => widget.oneRepMaxService
              .findOneRepMaxHistoryForExercise(exercise.id)
              .map(
                (historyOption) => historyOption
                    .map((history) => history.findCurrentOneRepMax())
                    .flatMap((historyOption) => historyOption),
              )
              .map(
                (oneRepMax) => _SectionEntryData(
                  name: exercise.name,
                  oneRepMax: oneRepMax,
                ),
              ),
        )
        .joinAll()
        .run();
  }
}
