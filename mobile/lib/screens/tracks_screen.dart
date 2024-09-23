import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/screens/running_form_screen.dart';
import 'package:pi_mobile/widgets/activity_tile.dart';
import 'package:pi_mobile/widgets/app_navigation_drawer.dart';

class TracksScreen extends StatelessWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: context.colors.scaffoldBackground,
        title: const Text("Tracks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            ActivityTile(
                headline: 'Bieg',
                imagePath: "assets/running.png",
                screen: RunningFormScreen()),
            ActivityTile(
                headline: 'Chód/Spacer',
                imagePath: "assets/walking.png",
                screen: RunningFormScreen()),
            ActivityTile(
                headline: 'Jazda na rowerze',
                imagePath: "assets/cycling.png",
                screen: RunningFormScreen()),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String activity, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RunningFormScreen()),
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(imagePath),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(activity),
            ),
          ],
        ),
      ),
    );
  }
}
