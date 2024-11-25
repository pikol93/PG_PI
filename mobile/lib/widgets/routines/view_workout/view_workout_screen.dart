import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart" as fpdart;
import "package:pi_mobile/data/routine/routine.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise_models_provider.dart";
import "package:pi_mobile/provider/one_rep_max_service_provider.dart";
import "package:pi_mobile/provider/routine/active_session_service_provider.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/utility/map.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";
import "package:pi_mobile/widgets/routines/common/section_content.dart";
import "package:pi_mobile/widgets/routines/common/section_header.dart";

class ViewWorkoutScreen extends ConsumerWidget {
  final int routineId;
  final int workoutId;

  const ViewWorkoutScreen({
    super.key,
    required this.routineId,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(
        appBar: AppBar(
          title: const Text("Workout"), // TODO: I18N
        ),
        body: ref.watch(routinesMapProvider).whenDataOrEmptyScaffold(
          context,
          (routinesMap) {
            final workout = routinesMap
                .get(routineId)
                .map(
                  (routine) => routine.workouts
                      .where((workout) => workout.id == workoutId)
                      .firstOption,
                )
                .flatMap((value) => value)
                .toNullable();

            if (workout == null) {
              return _MissingWorkout(
                routineId: routineId,
                workoutId: workoutId,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  _WorkoutHistorySection(workout: workout),
                  _ExercisesSection(
                    routineId: routineId,
                    workout: workout,
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class _MissingWorkout extends StatelessWidget {
  final int routineId;
  final int workoutId;

  const _MissingWorkout({required this.routineId, required this.workoutId});

  @override
  Widget build(BuildContext context) => Center(
        child: Text("Missing workout: $routineId, $workoutId"),
      );
}

class _WorkoutHistorySection extends StatelessWidget with Logger {
  final Workout workout;

  const _WorkoutHistorySection({required this.workout});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: SectionHeader(title: workout.name)),
                ElevatedButton(
                  onPressed: () => onViewHistoryPressed(context),
                  child: const Text("View history"), // TODO: I18N
                ),
              ],
            ),
          ),
          const Text("No session in history."),
        ],
      );

  void onViewHistoryPressed(BuildContext context) {
    logger.debug("On view history pressed for workout ${workout.name}");
  }
}

class _ExercisesSection extends StatelessWidget {
  final int routineId;
  final Workout workout;

  const _ExercisesSection({required this.routineId, required this.workout});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(title: "Exercises"), // TODO: I18N
          Column(
            children: workout.exercises
                .map(
                  (exercise) => _ExerciseDetails(
                    routineId: routineId,
                    workout: workout,
                    exercise: exercise,
                  ),
                )
                .toList(),
          ),
        ],
      );
}

class _ExerciseDetails extends ConsumerWidget with Logger {
  final int routineId;
  final Workout workout;
  final WorkoutExercise exercise;

  const _ExerciseDetails({
    required this.routineId,
    required this.workout,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SectionContent(
        child: Column(
          children: [
            _ExerciseDetailsHeader(
              routineId: routineId,
              workout: workout,
              exercise: exercise,
            ),
            _ExerciseDetailsSets(exercise: exercise),
          ],
        ),
      );
}

class _ExerciseDetailsHeader extends ConsumerWidget with Logger {
  final int routineId;
  final Workout workout;
  final WorkoutExercise exercise;

  const _ExerciseDetailsHeader({
    required this.routineId,
    required this.workout,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.fitness_center, size: 40.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _readExerciseName(ref),
                style: context.textStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _onStartPressed(context, ref),
            child: const Text("Start"), // TODO: I18N
          ),
        ],
      );

  String _readExerciseName(WidgetRef ref) => ref
      .watch(exerciseModelsMapProvider)
      .maybeWhen(
        orElse: fpdart.Option.none,
        data: (map) => map
            .get(exercise.exerciseId)
            .map((exerciseModel) => exerciseModel.name),
      )
      .getOrElse(() => "Unknown exercise");

  Future<void> _onStartPressed(BuildContext context, WidgetRef ref) async {
    logger.debug("Start pressed for exercise ${exercise.exerciseId}");
    final result = await ref
        .read(activeSessionServiceProvider)
        .initiate(routineId, workout.id, const fpdart.Option.none())
        .run();

    logger.debug("Start result: $result");
  }
}

class _ExerciseDetailsSets extends ConsumerWidget {
  final WorkoutExercise exercise;

  const _ExerciseDetailsSets({required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(oneRepMaxServiceProvider).whenDataOrDefault(
            context,
            (service) => _ExerciseDetailsSetsTable(
              exercise: exercise,
              oneRepMaxService: service,
            ),
          );
}

class _ExerciseDetailsSetsTable extends StatefulWidget {
  final WorkoutExercise exercise;
  final OneRepMaxService oneRepMaxService;

  const _ExerciseDetailsSetsTable({
    required this.exercise,
    required this.oneRepMaxService,
  });

  @override
  State<_ExerciseDetailsSetsTable> createState() =>
      _ExerciseDetailsSetsTableState();
}

class _ExerciseDetailsSetsTableState extends State<_ExerciseDetailsSetsTable> {
  late Future<fpdart.Option<double>> oneRepMaxFuture;

  @override
  void initState() {
    super.initState();

    oneRepMaxFuture = widget.oneRepMaxService
        .findOneRepMaxHistoryForExercise(widget.exercise.exerciseId)
        .map(
          (optionHistory) => optionHistory.flatMap(
            (history) => history.findCurrentOneRepMax(),
          ),
        )
        .run();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: oneRepMaxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final oneRepMax = snapshot.data!;
          return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(
              horizontalInside: BorderSide(
                width: 0.5,
                color: context.colors.primary,
              ),
            ),
            children: [header(context)]
                .concat(
                  widget.exercise.sets.indexed.map(
                    (index) => row(context, index.$1 + 1, index.$2, oneRepMax),
                  ),
                )
                .toList(),
          );
        },
      );

  TableRow header(BuildContext context) {
    final textStyle = context.textStyles.bodyMedium.copyWith(
      fontWeight: FontWeight.w800,
    );

    return TableRow(
      children: [
        Text(
          "Set", // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          "Intensity", // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          "Weight", // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          "Reps", // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ],
    );
  }

  TableRow row(
    BuildContext context,
    int index,
    ExerciseSet set,
    fpdart.Option<double> oneRepMax,
  ) {
    final textStyle = context.textStyles.bodyMedium.copyWith(
      fontWeight: FontWeight.w300,
    );

    return TableRow(
      children: [
        Text(
          "$index", // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          formatIntensity(set.intensity), // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          formatWeight(oneRepMax, set.intensity),
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Text(
          formatReps(set.reps, set.isAmrap), // TODO: I18N
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ],
    );
  }

  static String formatIntensity(double value) {
    final percentValue = value * 100.0;
    return "${percentValue.round()} %";
  }

  static String formatWeight(
    fpdart.Option<double> oneRepMax,
    double intensity,
  ) =>
      oneRepMax
          .map(
            (oneRepMax) => "${(oneRepMax * intensity).toStringAsFixed(1)} kg",
          )
          .getOrElse(() => "-");

  static String formatReps(int reps, bool isAmrap) =>
      "$reps${isAmrap ? "+" : ""}";
}
