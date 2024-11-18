import "package:flutter/material.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/routing/routes_old_exercises.dart";

class RoutinesListWidget extends StatelessWidget {
  final List<RoutineSchema> routines;

  const RoutinesListWidget({super.key, required this.routines});

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return ListTile(
            title: Text(routine.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _onStartRoutine(context, routine),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _onEditRoutine(context, routine),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _onDeleteRoutine(context, routine),
                ),
              ],
            ),
            onTap: () {
              _onStartRoutine(context, routine);
            },
          );
        },
      );

  void _onStartRoutine(BuildContext context, RoutineSchema routine) {
    OpenRoutineTrainingRoute(routineUuid: routine.uuid).go(context);
  }

  void _onEditRoutine(BuildContext context, RoutineSchema routine) {
    EditRoutineSchemaRoute(routineUuid: routine.uuid).go(context);
  }

  void _onDeleteRoutine(BuildContext context, RoutineSchema routine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.routines.delete),
        content: Text(
          "${context.t.routines.areYouSureYouWantToDelete} "
          '"${routine.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.t.common.dismiss),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${context.t.routines.gotDeleted}: ${routine.name}",
                  ),
                ),
              );
            },
            child: Text(context.t.common.delete),
          ),
        ],
      ),
    );
  }
}
