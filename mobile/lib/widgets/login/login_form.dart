import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/service/auth_service.dart";

class LoginForm extends ConsumerStatefulWidget {
  final Function(LoginError) onLoginFailed;

  const LoginForm({
    super.key,
    required this.onLoginFailed,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> with Logger {
  final userTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    userTextController.dispose();
    passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: context.textStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32.0),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                hintText: "Enter username",
              ),
              controller: userTextController,
              validator: _validateLoginField,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                hintText: "Enter password",
              ),
              controller: passwordTextController,
              validator: _validatePasswordField,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _onForgotPasswordTapped,
                  child: const Text("Forgot password?"),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _onLoginButtonPressed,
              child: const Text("Log in"),
            ),
          ],
        ),
      );

  String? _validateLoginField(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your username";
    }

    return null;
  }

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your password";
    }

    return null;
  }

  Future<void> _onLoginButtonPressed() async {
    final currentState = formKey.currentState;
    if (currentState == null) {
      logger.warning("Current state is null.");
      return;
    }

    final validated = currentState.validate();
    if (!validated) {
      logger.warning("Input is not validated.");
      return;
    }

    final username = userTextController.text;
    if (username.isEmpty) {
      logger.debug("Cannot log in with empty username.");
      return;
    }

    logger.debug("Login button pressed. Username = $username");
    final loginError = await ref.read(authServiceProvider).logIn(username);
    if (loginError == null) {
      logger.debug("No error resulting from logging in.");
      return;
    }

    if (mounted) {
      widget.onLoginFailed(loginError);
    }
  }

  void _onForgotPasswordTapped() {
    logger.debug("Forgot password tapped.");
    const ForgotPasswordRoute().push(context);
  }
}
