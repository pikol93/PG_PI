import 'package:flutter/material.dart';
import 'package:pi_mobile/navigation_drawer_entry.dart';
import 'package:pi_mobile/app_route.dart';

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
            appRoute: AppRoute.home,
            icon: Icons.home,
            text: "Strona główna",
            onTap: _onEntrySelected,
          ),
          NavigationDrawerEntry(
            appRoute: AppRoute.navigation,
            icon: Icons.navigation,
            text: "Trasy",
            onTap: _onEntrySelected,
          ),
          NavigationDrawerEntry(
            appRoute: AppRoute.workout,
            icon: Icons.fitness_center,
            text: "Ćwiczenia",
            onTap: _onEntrySelected,
          ),
          NavigationDrawerEntry(
            appRoute: AppRoute.settings,
            icon: Icons.settings,
            text: "Ustawienia",
            onTap: _onEntrySelected,
          ),
        ],
      ),
    );
  }

  void _onEntrySelected(AppRoute route) {
    print(route);
  }
}
