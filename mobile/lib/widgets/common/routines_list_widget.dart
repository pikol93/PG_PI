import "package:flutter/material.dart";
import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/routing/routes.dart";

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
            subtitle: Text(routine.uuid),
            onTap: () {
              _onTap(context, routine.uuid);
            },
          );
        },
      );

  void _onTap(BuildContext context, String routineUuid) {
    EditRoutineSchemaRoute(routineUuid: routineUuid).go(context);
  }
}
