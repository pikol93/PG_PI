import 'package:flutter/material.dart';
import 'package:pi_mobile/i18n/strings.g.dart';
import 'package:pi_mobile/routes.dart';
import 'package:pi_mobile/widgets/common/navigation_drawer_entry.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("my stronk account name"),
            accountEmail: const Text("stronk@email.mail"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/stronk.png"),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              image: DecorationImage(
                image: AssetImage("assets/stronk_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          NavigationDrawerEntry(
            goMethod: const HomeRoute().go,
            icon: Icons.home,
            text: context.t.home.title,
          ),
          NavigationDrawerEntry(
            goMethod: const TracksRoute().go,
            icon: Icons.navigation,
            text: context.t.tracks.title,
          ),
          NavigationDrawerEntry(
            goMethod: const ExercisesRoute().go,
            icon: Icons.fitness_center,
            text: context.t.exercises.title,
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
}