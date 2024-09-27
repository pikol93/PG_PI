import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/service/auth_service.dart";
import "package:pi_mobile/widgets/login/login_form.dart";

class LoginScreen extends StatelessWidget with Logger {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onSettingsPressed(context),
          child: const Icon(Icons.settings),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: LoginForm(
                  onLoginFailed: (error) => _onLoginFailed(context, error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _onSignUpTapped(context),
                child: Text(
                  "Don't have an account? Sign up.",
                  style: context.textStyles.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      );

  void _onSignUpTapped(BuildContext context) {
    logger.debug("Sign up tapped.");
    const RegisterRoute().push(context);
  }

  void _onSettingsPressed(BuildContext context) {
    logger.debug("Welcome settings button pressed.");
    const WelcomeSettingsRoute().push(context);
  }

  void _onLoginFailed(BuildContext context, LoginError error) {
    logger.debug("Failed logging in. Error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.name),
      ),
    );
  }
}
