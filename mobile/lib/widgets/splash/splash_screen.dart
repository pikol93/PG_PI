import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("TODO: Splash screen"),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
