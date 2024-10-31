import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/routines_list_widget.dart";
import "package:uuid/uuid.dart";

class RoutinesScreen extends ConsumerStatefulWidget with Logger {
  const RoutinesScreen({super.key});

  @override
  ConsumerState<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends ConsumerState<RoutinesScreen> {
  final List<Workload> exercises = [];
  final List<RoutineSchema> routineSchemas = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.exercises.trainingSession),
        ),
        body: ref.watch(routinesProvider).when(
              error: (error, stack) => Text("Could not fetch routines. $error"),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (routines) => RoutinesListWidget(routines: routines),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _onAddButtonPressed(context);
          },
          tooltip: "Dodaj nową rutynę",
          child: const Icon(Icons.add),
        ),
      );

  Future<void> _onAddButtonPressed(BuildContext context) async {
    final routineUuid = const Uuid().v4();

    await ref.read(routinesProvider.notifier).addRoutine(
          RoutineSchema(
            uuid: routineUuid,
            name: "",
            description: "",
            workouts: [],
          ),
        );

    if (context.mounted) {
      EditRoutineSchemaRoute(routineUuid: routineUuid).go(context);
    }
  }
}
