import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/workout.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/exercises/session/workout_session_screen.dart";
import "package:uuid/uuid.dart";

import "../../provider/workouts_provider.dart";
import "session/history_screen.dart";

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  final sessionHistory = <Workout>[];

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AppNavigationDrawer(),
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: Text(context.t.exercises.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final uuid = const Uuid().v4();
                  final emptyWorkout = Workout(
                    uuid: uuid,
                    date: DateTime.now(),
                    exercises: [],
                  );
                  await ref
                      .read(workoutsProvider.notifier)
                      .addWorkout(emptyWorkout);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutSessionScreen(uuid: uuid),
                    ),
                  );
                },
                child: Text(context.t.exercises.start),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                child: Text(context.t.exercises.history),
              ),
            ],
          ),
        ),
      );
}
