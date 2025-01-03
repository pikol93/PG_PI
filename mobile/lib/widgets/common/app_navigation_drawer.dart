import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/routing/routes_exercises.dart";
import "package:pi_mobile/routing/routes_heart_rate.dart";
import "package:pi_mobile/routing/routes_routines.dart";
import "package:pi_mobile/routing/routes_sessions.dart";
import "package:pi_mobile/routing/routes_tracks.dart";
import "package:pi_mobile/widgets/common/navigation_drawer_entry.dart";

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("PG_PI"),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset("assets/icon_display.png"),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                image: DecorationImage(
                  image: AssetImage("assets/navigation_drawer_backdrop.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            NavigationDrawerEntry(
              goMethod: const RoutinesRoute().go,
              icon: Icons.accessibility,
              text: context.t.routines.title,
            ),
            NavigationDrawerEntry(
              goMethod: const ExercisesRoute().go,
              icon: Icons.fitness_center,
              text: context.t.exercises.title,
            ),
            NavigationDrawerEntry(
              goMethod: const SessionsHistoryRoute().go,
              icon: Icons.history,
              text: context.t.sessions.history.title,
            ),
            NavigationDrawerEntry(
              goMethod: const TracksRoute().go,
              icon: Icons.navigation,
              text: context.t.tracks.title,
            ),
            NavigationDrawerEntry(
              goMethod: const CalendarRoute().go,
              icon: Icons.calendar_month,
              text: context.t.calendar.title,
            ),
            NavigationDrawerEntry(
              goMethod: const HeartRateRoute().go,
              icon: Icons.monitor_heart_outlined,
              text: context.t.heartRate.title,
            ),
            NavigationDrawerEntry(
              goMethod: const SettingsRoute().go,
              icon: Icons.settings,
              text: context.t.settings.title,
            ),
          ],
        ),
      );
}
