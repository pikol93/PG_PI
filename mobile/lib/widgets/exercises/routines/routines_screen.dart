import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routines_provider.dart";
import "package:pi_mobile/widgets/exercises/routines/new_routine_schema_screen.dart";

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
              data: (routines) => ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: routines.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(routines[index].name),
                  subtitle: Text(routines[index].uuid),
                ),
              ),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRoutineSchemaScreen(),
              ),
            );
            if (result != null) {
              setState(() {
                routineSchemas.add(result);
              });
            }
          },
          tooltip: "Dodaj nową rutynę",
          child: const Icon(Icons.add),
        ),
      );

  // void _onAddButtonPressed(BuildContext context) {
  //   // logger.debug("Add routine button pressed");
  //   const AddRoutineRoute().go(context);
  // }
}
