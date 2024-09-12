import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/screens/login_screen.dart';
import 'package:pi_mobile/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "Welcome",
                style: context.textStyles.headlineLarge,
              ),
            ),
            TextButton(
              onPressed: () => _onLoginPressed(context),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => _onRegisterPressed(context),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    print("login");
  }

  void _onRegisterPressed(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
    print("register");
  }
}
