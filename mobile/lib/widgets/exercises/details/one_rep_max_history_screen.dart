import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart" as fpdart;
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise/one_rep_max_history.dart";
import "package:pi_mobile/provider/exercise/one_rep_max_service_provider.dart";
import "package:pi_mobile/provider/preferences/date_formatter_provider.dart";
import "package:pi_mobile/routing/routes_exercises.dart";
import "package:pi_mobile/utility/async_value.dart";
import "package:pi_mobile/widgets/common/scaffold/app_scaffold.dart";

class OneRepMaxHistoryScreen extends ConsumerWidget {
  final int exerciseId;

  const OneRepMaxHistoryScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(oneRepMaxServiceProvider).whenDataOrEmptyScaffold(
            context,
            (service) => AppScaffold(
              appBar: AppBar(
                title: Text(context.t.exercises.history1rm),
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _onAddButtonPressed(context),
              ),
              body: _ScreenBody(
                exerciseId: exerciseId,
                oneRepMaxService: service,
              ),
            ),
          );

  void _onAddButtonPressed(BuildContext context) {
    ExerciseAddSpecificOneRepMaxRoute(exerciseId: exerciseId).go(context);
  }
}

class _ScreenBody extends StatefulWidget {
  final int exerciseId;
  final OneRepMaxService oneRepMaxService;

  const _ScreenBody({
    required this.exerciseId,
    required this.oneRepMaxService,
  });

  @override
  State<StatefulWidget> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<_ScreenBody> {
  late Future<fpdart.Option<OneRepMaxHistory>> oneRepMaxHistoryFuture;

  @override
  void initState() {
    super.initState();
    _updateFuture();
  }

  @override
  void didUpdateWidget(covariant _ScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(_updateFuture);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: oneRepMaxHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!
              .map((item) => _OneRepMaxEntries(history: item) as Widget)
              .getOrElse(_ScreenBodyNoEntries.new);
        },
      );

  void _updateFuture() {
    oneRepMaxHistoryFuture = widget.oneRepMaxService
        .findOneRepMaxHistoryForExercise(widget.exerciseId)
        .run();
  }
}

class _ScreenBodyNoEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Text(context.t.general.noData),
      );
}

class _OneRepMaxEntries extends StatelessWidget {
  final OneRepMaxHistory history;

  const _OneRepMaxEntries({required this.history});

  @override
  Widget build(BuildContext context) => ListView(
        children: history.oneRepMaxHistory.indexed
            .map(
              (item) => _OneRepMaxEntry(
                index: item.$1 + 1,
                exerciseId: history.exerciseId,
                entry: item.$2,
              ),
            )
            .toList(),
      );
}

class _OneRepMaxEntry extends ConsumerWidget with Logger {
  final int index;
  final int exerciseId;
  final OneRepMaxEntry entry;

  _OneRepMaxEntry({
    required this.index,
    required this.exerciseId,
    required this.entry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(dateFormatterProvider);
    final date = entry.dateTime;

    return InkWell(
      onTap: () => _onRowTapped(context, exerciseId, date),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              child: Text(
                textAlign: TextAlign.center,
                index.toString(),
                style: context.textStyles.titleLarge,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormatter.fullDate(date),
                  style: context.textStyles.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "${entry.value.toStringAsFixed(1)} kg",
                    style: context.textStyles.labelLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onRowTapped(BuildContext context, int exerciseId, DateTime dateTime) {
    logger.debug("Row tapped: $exerciseId, $dateTime");
    ExerciseModifySpecificOneRepMaxRoute(
      exerciseId: exerciseId,
      dateTimestamp: dateTime.millisecondsSinceEpoch,
    ).go(context);
  }
}
