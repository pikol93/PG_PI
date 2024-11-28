import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart" as fpdart;
import "package:pi_mobile/data/exercise/one_rep_max_history.dart";
import "package:pi_mobile/data/exercise/one_rep_max_service_provider.dart";
import "package:pi_mobile/data/preferences/date_formatter_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes_exercises.dart";
import "package:pi_mobile/utility/async_value.dart";

class ExerciseOneRepMaxSection extends ConsumerWidget {
  final int exerciseId;

  const ExerciseOneRepMaxSection({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(oneRepMaxServiceProvider).whenDataOrDefault(
            context,
            (service) => _ExerciseOneRepMaxSectionInternal(
              exerciseId: exerciseId,
              oneRepMaxService: service,
            ),
          );
}

class _ExerciseOneRepMaxSectionInternal extends StatefulWidget {
  final int exerciseId;
  final OneRepMaxService oneRepMaxService;

  const _ExerciseOneRepMaxSectionInternal({
    required this.exerciseId,
    required this.oneRepMaxService,
  });

  @override
  State<StatefulWidget> createState() =>
      _ExerciseOneRepMaxSectionInternalState();
}

class _ExerciseOneRepMaxSectionInternalState
    extends State<_ExerciseOneRepMaxSectionInternal> {
  late Future<fpdart.Option<OneRepMaxHistory>> oneRepMaxFuture;

  @override
  void initState() {
    super.initState();
    _updateFuture();
  }

  @override
  void didUpdateWidget(covariant _ExerciseOneRepMaxSectionInternal oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(_updateFuture);
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

          final listWidget = snapshot.data!
              .map((data) => _OneRepMaxList(oneRepMaxHistory: data) as Widget)
              .getOrElse(_OneRepMaxEmptyList.new);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OneRepMaxListHeader(exerciseId: widget.exerciseId),
              listWidget,
            ],
          );
        },
      );

  void _updateFuture() {
    oneRepMaxFuture = widget.oneRepMaxService
        .findOneRepMaxHistoryForExercise(widget.exerciseId)
        .run();
  }
}

class _OneRepMaxListHeader extends StatelessWidget with Logger {
  final int exerciseId;

  const _OneRepMaxListHeader({
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              context.t.exercises.sectionTitle1rm,
              style: context.textStyles.headlineMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _onModifyPressed(context),
                child: Text(context.t.exercises.modify1rm),
              ),
            ],
          ),
        ],
      );

  void _onModifyPressed(BuildContext context) {
    logger.debug("Modify pressed for $exerciseId");
    ExerciseModifyOneRepMaxRoute(exerciseId: exerciseId).go(context);
  }
}

class _OneRepMaxEmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(context.t.general.noData),
        ),
      );
}

class _OneRepMaxList extends ConsumerWidget {
  final OneRepMaxHistory oneRepMaxHistory;

  const _OneRepMaxList({
    required this.oneRepMaxHistory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(dateFormatterProvider);

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Text(context.t.general.date),
            const Text("1RM (kg)"),
          ],
        ),
      ]
          .concat(
            oneRepMaxHistory.oneRepMaxHistory
                .sortedBy((item) => item.dateTime)
                .reversed
                .map(
                  (item) => TableRow(
                    children: [
                      Text(dateFormatter.onlyNumbersDate(item.dateTime)),
                      Text(item.value.toStringAsFixed(1)),
                    ],
                  ),
                ),
          )
          .toList(),
    );
  }
}
