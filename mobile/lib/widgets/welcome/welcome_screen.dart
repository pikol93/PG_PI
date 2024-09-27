import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";

class WelcomeScreen extends StatelessWidget with Logger {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onSettingsPressed(context),
          child: const Icon(Icons.settings),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      context.t.welcome.welcome,
                      style: context.textStyles.headlineLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _onLoginPressed(context),
                    child: Text(context.t.welcome.login),
                  ),
                  TextButton(
                    onPressed: () => _onRegisterPressed(context),
                    child: Text(context.t.welcome.register),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _onLoginPressed(BuildContext context) {
    const LoginRoute().go(context);
    logger.debug("login");
  }

  void _onRegisterPressed(BuildContext context) {
    const RegisterRoute().go(context);
    logger.debug("register");
  }

  void _onSettingsPressed(BuildContext context) {
    logger.debug("Welcome settings button pressed.");
    const WelcomeSettingsRoute().go(context);
  }
}
