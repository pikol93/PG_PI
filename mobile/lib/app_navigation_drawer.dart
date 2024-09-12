import 'package:flutter/material.dart';
import 'package:pi_mobile/navigation_drawer_entry.dart';
import 'package:pi_mobile/routes/logged_in/logged_in_app_route.dart';

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
          const NavigationDrawerEntry(
            appRoute: LoggedInAppRoute.home,
            icon: Icons.home,
            text: "Strona główna",
          ),
          const NavigationDrawerEntry(
            appRoute: LoggedInAppRoute.navigation,
            icon: Icons.navigation,
            text: "Trasy",
          ),
          const NavigationDrawerEntry(
            appRoute: LoggedInAppRoute.workout,
            icon: Icons.fitness_center,
            text: "Ćwiczenia",
          ),
          const NavigationDrawerEntry(
            appRoute: LoggedInAppRoute.settings,
            icon: Icons.settings,
            text: "Ustawienia",
          ),
        ],
      ),
    );
  }
}
