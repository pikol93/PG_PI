import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/workout.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/workouts_provider.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/exercises/session/workout_session_screen.dart";
import "package:uuid/uuid.dart";

class ExercisesScreen extends ConsumerStatefulWidget with Logger {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
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
                onPressed: () {
                  _onRoutinesButtonPressed(context);
                },
                child: Text(context.t.routines.title),
              ),
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
                  if (context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutSessionScreen(),
                      ),
                    );
                  }
                },
                child: Text(context.t.exercises.start),
              ),
              ElevatedButton(
                onPressed: () {
                  _onShowHistoryButtonPressed(context);
                },
                child: Text(context.t.exercises.history),
              ),
            ],
          ),
        ),
      );

  // void _onStartTrainingButtonPressed(BuildContext context) {
  //   // logger.debug("Start training button presses");
  //   final uuid = const Uuid().v4();
  //   final emptyWorkout = Workout(
  //     uuid: uuid,
  //     date: DateTime.now(),
  //     exercises: [],
  //   );
  //   await ref
  //       .read(workoutsProvider.notifier)
  //       .addWorkout(emptyWorkout);
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => WorkoutSessionScreen(uuid: uuid),
  //     ),
  //   );
  //   const StartTrainingRoute().go(context);
  // }

  void _onRoutinesButtonPressed(BuildContext context) {
    // logger.debug("Routine screen button pressed");
    const RoutinesRoute().go(context);
  }

  void _onShowHistoryButtonPressed(BuildContext context) {
    // logger.debug("History screen button pressed");
    const HistoryRoute().go(context);
  }
}
