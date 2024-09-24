import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/routing/routes.dart';
import 'package:pi_mobile/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget with Logger {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: LoginForm(),
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
  }

  void _onSignUpTapped(BuildContext context) {
    logger.debug("Sign up tapped.");
    const RegisterRoute().push(context);
  }
}
